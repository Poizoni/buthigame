<template>
	<div class="toolbar">
		<div class="tools">
			<div class="toggles">
				<div class="tool switch">
					<p>user</p>
					<div class="toggle off" :class="{ on: $parent.userSwitchOn }">
						<div class="toggle-side toggle-side_off" :class="{ on: $parent.userSwitchOn }"></div>
						<div class="toggle-switch" :class="{ on: $parent.userSwitchOn }" @click="$parent.userSwitchOn = !$parent.userSwitchOn; checkAny();"></div>
						<div class="toggle-side toggle-side_on" :class="{ on: $parent.userSwitchOn }"></div>
					</div>
				</div>
				<div class="tool switch">
					<p>date</p>
					<div class="toggle off" :class="{ on: $parent.dateSwitchOn }">
						<div class="toggle-side toggle-side_off" :class="{ on: $parent.dateSwitchOn }"></div>
						<div class="toggle-switch" :class="{ on: $parent.dateSwitchOn }" @click="$parent.dateSwitchOn = !$parent.dateSwitchOn; checkAny();"></div>
						<div class="toggle-side toggle-side_on" :class="{ on: $parent.dateSwitchOn }"></div>
					</div>
				</div>
			</div>
			<div class="buttons">
				<button class="tool" @click=" openGuideModal() ">Guide</button>
				<div class="tool load" v-if=" isLoading ">
					<div class="spinner"></div>
				</div>
				<button class="tool" @click=" start() " v-if=" !isStarted && !isLoading ">Start</button>
				<button class="tool" @click=" nextClick() " v-if=" isStarted && !isLoading">Next</button>
			</div>
		</div>
		<div class="inputTool">
			<div class="inputToolLeft">
				<label for="input">taxon</label>
				<input name="input" type="text" v-model="input">
			</div>
			<div class="inputToolRight">
				<button @click=" checkInput() ">get</button>
				<div class="check" v-if=" isInvalid ">invalid</div>
				<div class="check" v-if=" !isInvalid ">valid</div>
			</div>
		</div>
		<div class="score-box">
			<p class="score">Score {{ score }}</p>
		</div>
	</div>
</template>

<script>
	export default {
	name: "ButhiToolbar",
	props: {
		score: Number,
	},
	data() {
		return {
		isStarted: false,
		isInvalid: false,
		isLoading: false,
		input: "",
		onStart: 0,
		};
	},
	methods: {
		checkAny() {
		if (this.$parent.userSwitchOn || this.$parent.dateSwitchOn) {
			this.$parent.anyOn = true;
		} else {
			this.$parent.anyOn = false;
		}
		},
		openGuideModal() {
		this.$parent.openGuideModal();
		},
		start() {
		this.isStarted = true;
		this.nextClick();
		},
		nextClick() {
		this.setPages();
		this.fetchScorpions();

		if (this.$parent.apiResult !== undefined) {
			this.$parent.subspecies = undefined;
			this.$parent.hideNames();
			this.$parent.changePic();
			this.$parent.setNames();
			var guess = this.$parent.getOneName();
			this.$parent.genus = guess.split(" ")[0];
			this.$parent.species = guess.split(" ")[1];
			if (guess.split(" ").length > 2) {
			this.$parent.subspecies = guess.split(" ")[2];
			}
			this.$parent.setLocation();

			this.$parent.firstWin = false;
			this.$parent.secondWin = false;
			this.$parent.thirdWin = false;
			this.$parent.fourthWin = false;

			this.$parent.firstLose = false;
			this.$parent.secondLose = false;
			this.$parent.thirdLose = false;
			this.$parent.fourthLose = false;

			this.$parent.isDisabled = false;
		}
		},
		async fetchScorpions() {
		if (this.onStart === 0) this.isLoading = true;
		Promise.all([
			await fetch(
			`${
				this.$parent.url_base
			}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
				this.$parent.query
			}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
				this.$parent.perpage
			}`
			),
			await fetch(
			`${
				this.$parent.url_base
			}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
				this.$parent.query
			}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
				this.$parent.perpage
			}`
			),
			await fetch(
			`${
				this.$parent.url_base
			}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
				this.$parent.query
			}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
				this.$parent.perpage
			}`
			),
			await fetch(
			`${
				this.$parent.url_base
			}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
				this.$parent.query
			}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
				this.$parent.perpage
			}`
			),
		])
			.then(function (responses) {
			return Promise.all(
				responses.map(function (response) {
				return response.json();
				})
			);
			})
			.then((response) => {
			this.$parent.setResults(response);
			if (this.onStart === 0) this.isLoading = false;
			this.onStart = 1;
			})
			.catch((err) => {
			console.error("error", err);
			});
		},
		randomPage() {
		return Math.floor(Math.random() * this.$parent.pageCount) + 1;
		},
		async checkInput() {
		this.$parent.apiResult = undefined;
		this.isLoading = true;

		await fetch(
			`https://api.inaturalist.org/v1/taxa?q=${this.input}&is_active=any&per_page=1`
		)
			.then((response) => response.json())
			.then((data) => {
			this.setQuery(data);
			this.isLoading = false;
			this.onStart = 0;
			})
			.catch((error) => {
			console.error("eror" + error);
			this.isInvalid = true;
			});

		this.setPages();
		},
		async setPages() {
		await fetch(
			`${this.$parent.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${this.$parent.query}&place_id=&order_by=votes&quality_grade=research&page=1&per_page=1`
		)
			.then((response) => response.json())
			.then((data) => {
			if (data.total_results < 10) {
				this.isInvalid = true;
			}
			if (Math.round(data.total_results / this.$parent.perpage) > 1000) {
				this.$parent.pageCount = 1000;
			} else {
				this.$parent.pageCount = Math.round(
				data.total_results / this.$parent.perpage
				);
			}

			if (this.$parent.pageCount === 0) {
				this.isInvalid = true;
			}
			})
			.catch((error) => {
			console.error("error" + error);
			});
		},
		setQuery(data) {
		try {
			this.$parent.query = data.results[0].id;
			this.isInvalid = false;
		} catch (err) {
			this.isInvalid = true;
			console.error("error" + err);
		}
		},
	},
	};
</script>

<style lang="scss" scoped>
	@import "@/assets/global.scss";

	.toolbar {
	box-shadow: inset 0 7px 9px -7px rgba(0, 0, 0, 0.2);

	padding-top: 10px;
	width: 100px;

	display: flex;
	padding-bottom: 10px;
	flex-direction: column-reverse;
	justify-content: space-between;
	background-color: $dark3;

	.inputTool {
		justify-self: center;
		padding: 3px;
		display: flex;
		flex-direction: column;
		align-items: center;
		.inputToolLeft {
		text-align: center;
		}
		.inputToolRight {
		display: flex;
		flex-direction: column;
		align-items: center;
		}
		input {
		all: unset;
		background-color: $dark2;
		width: 90px;
		height: 30px;
		margin-bottom: 10px;
		color: $light2;
		font-family: "Andale Mono", monospace;
		border-radius: 4px;
		}
		button {
		width: 40px;
		height: 20px;
		background-color: $light2;
		border: none;
		border-radius: 4px;
		color: $dark2;
		font-family: "Andale Mono", monospace;
		}

		button:hover {
		border: 1px solid $dark3;
		}
		button:active {
		border: 2px solid $dark3;
		font-size: 11px;
		}

		label {
		color: $light2;
		font-family: "Andale Mono", monospace;
		font-size: 13px;
		margin-bottom: 2px;
		}
		.check {
		margin-top: 6px;
		color: $light2;
		font-family: "Andale Mono", monospace;
		font-size: 13px;
		font-weight: bold;
		}
	}
	.tool {
		width: 90%;
		transition: 0.1s;
		font-family: "Andale Mono", monospace;
		font-weight: bold;
		color: $dark2;
		height: 10vh;
		margin: 5px;
		border-radius: 25px;
		background-color: $light2;
		font-size: 20px;
		border: none;
	}
	.tool:hover {
		border: 3px solid $dark3;
	}
	.tool:active {
		border: 8px solid $dark3;
		font-size: 18px;
	}
	.load {
		display: flex;
		align-items: center;
		justify-content: center;
		.spinner {
		height: 25px;
		width: 25px;
		animation: rotation 0.5s infinite linear;
		border-left: 3px solid rgba(66, 61, 51, 0.15);
		border-right: 3px solid rgba(66, 61, 51, 0.15);
		border-bottom: 3px solid rgba(66, 61, 51, 0.15);
		border-top: 3px solid rgba(66, 61, 51, 0.8);
		border-radius: 100%;
		}

		@keyframes rotation {
		from {
			transform: rotate(0deg);
		}
		to {
			transform: rotate(359deg);
		}
		}
	}
	.load:hover {
		border: none;
	}
	.load:active {
		border: none;
	}
	.switch {
		display: flex;
		align-items: center;
		justify-content: center;
		flex-direction: column;
		background-color: $dark3;
		height: 5vh;
		p {
		color: $light2;
		font-size: 15px;
		margin: 0;
		}
		.toggle {
		display: inline-block;
		height: 20px;
		user-select: none;

		.toggle-side,
		.toggle-switch {
			display: inline-block;
			vertical-align: middle;
		}
		.toggle-switch {
			width: 50px;
			background: $light;
			height: 100%;
			border-radius: 20px;
			margin: 0 0.5em;
			position: relative;
			cursor: pointer;

			&:after {
			content: "";
			display: inline-block;
			width: 25px;
			height: 25px;
			position: absolute;
			border-radius: 50%;
			background: $dark4;
			box-shadow: 0 0 1px rgba(0, 0, 0, 0.7);
			top: -2px;
			left: 0;
			transition: transform 0.1s, left 0.3s;
			transform-origin: 50% 50%;
			}

			&:active {
			&:after {
				transform: scaleY(0.9);
			}
			}
		}

		&.on {
			.toggle-side.toggle-side_off {
			color: #808080;
			}
			.toggle-side.toggle-side_on {
			color: #4fc1e9;
			}
			.toggle-switch {
			background: var(--toggleBg, $dark2);

			&:after {
				left: 60%;
				background: var(--toggleSwitch, darken($dark4, 25%));
			}
			}
		}
		}
	}
	.switch:hover {
		border: none;
	}
	.switch:active {
		border: none;
	}
	.score-box {
		text-align: center;
		font-size: 30px;
		font-family: "Andale Mono", monospace;
		font-weight: bold;
		color: $light2;
		margin-left: 5px;
		margin-right: 5px;
	}
	}

	@media (max-width: 960px) {
	.toolbar {
		padding: 10px;
		height: 90px;
		width: auto;
		display: flex;
		flex-direction: row-reverse;
		justify-content: space-between;
		align-items: center;
		.tools {
		display: flex;
		}
		.tool {
		flex: 1;
		width: 20vw;
		margin-left: 10px;
		height: 80px;
		}
		.toggles {
		display: flex;
		flex-direction: column;
		width: 20vw;
		}
		.buttons {
		display: flex;
		flex-direction: column;

		width: 20vw;
		margin-right: 8px;
		}
		.inputTool {
		display: flex;
		flex-direction: row;
		flex: 0;
		.inputToolLeft {
			display: flex;
			flex-direction: column;
			align-items: center;
			margin-right: 10px;
		}
		}
		.score-box {
		padding: 5px;
		height: auto;
		margin: 0;
		justify-content: center;
		font-size: 5vw;
		}
	}
	}
</style>