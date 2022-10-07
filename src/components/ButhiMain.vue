<template>
	<div class="body">
		<div class="row1">
			<div class="grid">
				<img v-bind:src=$parent.first alt="">
				<button @click=" showNames(); firstClick(); " class="btn" :class="{ win: $parent.firstWin, lose: $parent.firstLose, disabled: $parent.isDisabled }">
					<div v-if="$parent.anyOn" class="top">
						<span v-if="$parent.dateSwitchOn">{{ $parent.firstDate }}</span>
						<span v-if="$parent.userSwitchOn">{{ $parent.firstUser }}</span>
					</div>
					<span v-if="showingNames">{{ $parent.firstname }}</span>
				</button>
				<div v-if="showingMaps" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.firstMap" class="fa fa-map-marker "></a>
				</div>
				<div v-if="showingNames" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.firstLink" class="fa fa-external-link"></a>
				</div>
			</div>
			<div class="grid">
				<img v-bind:src=$parent.second alt="">
				<button @click=" showNames(); secondClick(); " class="btn" :class="{ win: $parent.secondWin, lose: $parent.secondLose, disabled: $parent.isDisabled }">
					<div v-if="$parent.anyOn" class="top">
						<span v-if="$parent.dateSwitchOn">{{ $parent.secondDate }}</span>
						<span v-if="$parent.userSwitchOn">{{ $parent.secondUser }}</span>
					</div>
					<span v-if="showingNames">{{ $parent.secondname }}</span>
				</button>
				<div v-if="showingMaps" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.secondMap" class="fa fa-map-marker "></a>
				</div>
				<div v-if="showingNames" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.secondLink" class="fa fa-external-link"></a>
				</div>
			</div>
		</div>
		<div class="row2">
			<div class="grid">
				<img v-bind:src=$parent.third alt="">
				<button @click=" showNames(); thirdClick(); " class="btn" :class="{ win: $parent.thirdWin, lose: $parent.thirdLose, disabled: $parent.isDisabled }">
					<div v-if="$parent.anyOn" class="top">
						<span v-if="$parent.dateSwitchOn">{{ $parent.thirdDate }}</span>
						<span v-if="$parent.userSwitchOn">{{ $parent.thirdUser }}</span>
					</div>
					<span v-if="showingNames">{{ $parent.thirdname }}</span>
				</button>
				<div v-if="showingMaps" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.thirdMap" class="fa fa-map-marker "></a>
				</div>
				<div v-if="showingNames" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.thirdLink" class="fa fa-external-link"></a>
				</div>
			</div>
			<div class="grid">
				<img v-bind:src=$parent.fourth alt="">
				<button @click=" showNames(); fourthClick(); " class="btn" :class="{ win: $parent.fourthWin, lose: $parent.fourthLose, disabled: $parent.isDisabled }">
					<div v-if="$parent.anyOn" class="top">
						<span v-if="$parent.dateSwitchOn">{{ $parent.fourthDate }}</span>
						<span v-if="$parent.userSwitchOn">{{ $parent.fourthUser }}</span>
					</div>
					<span v-if="showingNames">{{ $parent.fourthname }}</span>
				</button>
				<div v-if="showingMaps" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.fourthMap" class="fa fa-map-marker "></a>
				</div>
				<div v-if="showingNames" class="out">
					<a target="_blank" rel="noopener noreferrer" :href="$parent.fourthLink" class="fa fa-external-link"></a>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
	export default {
	name: "ButhiMain",
	data() {
		return {
		showingNames: false,
		showingMaps: false,
		};
	},
	mounted() {
		this.emitInterface();
	},
	methods: {
		showNames() {
		this.showingNames = true;
		},
		hideNames() {
		this.showingNames = false;
		},
		showMaps() {
			this.showingMaps = true;
		},
		hideMaps() {
			this.showingMaps = false;
		},
		firstClick() {
		this.hideMaps();
		this.$parent.isDisabled = true;
		if (this.$parent.firstname === this.$parent.getFullName()) {
			this.setScore();
			this.$parent.firstWin = true;
		} else {
			this.$parent.firstLose = true;
		}
		this.showNames();
		},
		secondClick() {
		this.hideMaps();
		this.$parent.isDisabled = true;
		if (this.$parent.secondname === this.$parent.getFullName()) {
			this.setScore();
			this.$parent.secondWin = true;
		} else {
			this.$parent.secondLose = true;
		}
		this.showNames();
		},
		thirdClick() {
		this.hideMaps();
		this.$parent.isDisabled = true;
		if (this.$parent.thirdname === this.$parent.getFullName()) {
			this.setScore();
			this.$parent.thirdWin = true;
		} else {
			this.$parent.thirdLose = true;
		}
		this.showNames();
		},
		fourthClick() {
		this.hideMaps();
		this.$parent.isDisabled = true;
		if (this.$parent.fourthname === this.$parent.getFullName()) {
			this.setScore();
			this.$parent.fourthWin = true;
		} else {
			this.$parent.fourthLose = true;
		}
		this.showNames();
		},
		setScore() {
		this.$parent.score++;
		},

		emitInterface() {
		this.$emit("interface", {
			hideNames: () => this.hideNames(),
			showMaps: () => this.showMaps(),
		});
		},
	},
	};
</script>

<style lang="scss" scoped>
	@import "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css";
	@import "@/assets/global.scss";

	.body {
	height: auto;
	position: relative;
	display: flex;
	flex: 1;
	grid-column: 2;
	flex-direction: column;
	.row1 {
		display: flex;
	}
	.row2 {
		display: flex;
	}
	.grid {
		margin: 20px;
		position: relative;
		width: 50%;
		display: flex;
		height: 42vh;
		align-items: center;
		justify-content: center;

		.btn > span {
		border-radius: 4px;
		background-color: $dark3;
		position: absolute;
		bottom: 0;
		left: 0;
		font-size: 3vw;
		color: $light2;
		outline: 2px solid $dark3;
		outline-offset: -1px;
		font-family: "Andale Mono", monospace;
		}
		.top {
		position: absolute;
		background-color: $dark3;
		top: 0;
		right: 0;
		outline: none;
		font-size: 1.5vw;
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		font-family: "Andale Mono", monospace;
		color: $light2;
		padding: 4px;
		border-radius: 5px;

		span {
			background-color: $dark3;
		}
		}
		.out {
		position: absolute;
		display: flex;
		justify-content: center;
		align-items: center;
		top: 0;
		left: 0;
		padding: 4px;
		border-radius: 4px;
		background-color: $dark3;
		transition: 0.1s;
		a {
			font-size: 24px;
			color: $light2;
			text-decoration: none;
		}
		a:hover {
			font-size: 26px;
		}
		a:active {
			font-size: 26px;
		}
		}
	}
	img {
		border: none;
		width: 100%;
		height: 100%;
		max-width: 100%;
		max-height: 100%;
		object-fit: cover;
	}
	.btn {
		box-shadow: 0px 8px 15px rgba(0, 0, 0, 0.3);

		border: none;
		position: absolute;
		top: 50%;
		left: 50%;
		transform: translate(-50%, -50%);
		-ms-transform: translate(-50%, -50%);
		width: 100%;
		height: 100%;
		background-color: transparent;
		outline: 10px solid $dark3;
		outline-offset: -2px;
		border-radius: 3px;
		transition: 0.2s;
	}
	.btn:hover {
		outline: 15px solid $dark3;
	}
	.btn:active {
		outline: none;
		outline: 2px solid $dark3;
	}
	.lose {
		background-color: rgba(255, 0, 0, 0.3);
	}
	.win {
		background-color: rgba(0, 255, 0, 0.3);
	}
	.disabled {
		pointer-events: none;
	}
	}

	@media (max-width: 960px) {
	.body {
		display: flex;
		overflow: auto;
		.grid {
		flex: 1;
		max-height: 36vh;

		.btn > span {
			padding-right: 5px;
			padding-left: 5px;
		}
		span {
			left: 1px;
			padding: 0;
		}
		.top {
			padding-right: 5px;
			padding-left: 5px;
			min-width: 20%;
			font-size: 12px;
		}
		}
		.row1,
		.row2 {
		height: auto !important;
		max-width: 100%;
		}
		.btn:hover {
		outline: 10px solid $dark3;
		}
		.btn:active {
		outline: none;
		outline: 5px solid $dark3;
		}
	}
	}
</style>