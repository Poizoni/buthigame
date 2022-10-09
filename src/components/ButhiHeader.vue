<template>
	<div class="header">
		<h1 class="title" id="left">ButhiGame</h1>
		<div id="center">
			<h2 class="genus">{{ genus }}</h2>
			<h2 class="species">{{ species }} {{ subspecies }}</h2>
		</div>
		<div id="right">
			<div class="inputTool">
			<div class="inputToolLeft">
				<label for="input">taxon</label>
				<input name="input" type="text" v-model="input">
			</div>
			<div class="inputToolRight">
				<button @click=" checkInput() ">get</button>
				<div class="check" v-if=" $parent.isInvalid ">invalid</div>
				<div class="check" v-if=" !$parent.isInvalid ">valid</div>
			</div>
		</div>
		</div>
	</div>
</template>

<script>
	export default {
		name: "ButhiHeader",
		props: {
			genus: String,
			species: String,
			subspecies: String,
		},
		data() {
			return {
			input: "",
			};
		},
		methods: {
			async checkInput() {
		this.$parent.apiResult = undefined;
		this.$parent.isLoading = true;

		await fetch(
			`https://api.inaturalist.org/v1/taxa?q=${this.input}&is_active=any&per_page=1`
		)
			.then((response) => response.json())
			.then((data) => {
			this.setQuery(data);
			this.$parent.isLoading = false;
			this.$parent.onStart = 0;
			})
			.catch((error) => {
			console.error("eror" + error);
			this.$parent.isInvalid = true;
			});

		this.$parent.setPages();
		},
		setQuery(data) {
		try {
			this.$parent.query = data.results[0].id;
			this.$parent.isInvalid = false;
		} catch (err) {
			this.$parent.isInvalid = true;
			console.error("error" + err);
		}
		},
		},
	};
</script>
<style lang="scss" scoped>
	@import "@/assets/global.scss";

	.header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		font-size: 70%;
		padding-left: 20px;
		padding-right: 20px;
		height: 70px;
		background-color: $dark2;
		color: $light2;
		font-family: "Andale Mono", monospace;

		#left,
		#right {
			flex-grow: 1;
			flex-basis: 0;
			display: flex;
		}
		#right {
			text-align: center;
			justify-content: flex-end;
		}
		#center {
			text-align: center;
		}
		.inputTool {
		padding: 3px;
		display: flex;
		flex-direction: row;
		align-items: center;
		.inputToolLeft {
		display: flex;
		flex-direction: column;
		text-align: center;
		margin-right: 20px;
		}
		.inputToolRight {
		display: flex;
		flex-direction: column;
		align-items: center;
		}
		input {
		all: unset;
		background-color: $dark3;
		width: 15vw;
		height: 30px;
		margin-bottom: 10px;
		font-size: 15px;
		color: $light2;
		font-family: "Andale Mono", monospace;
		border-radius: 4px;
		}
		input:focus {
		outline: 2px solid $dark3;
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
		.score-box {
			h1 {
				font-size: 40px;
				margin-top: 0;
				margin-bottom: 5px;
			}
			h2 {
			}
		}
	}

	@media (max-width: 960px) {
		#center {
			margin-right: 6px;
			margin-left: 6px;
		}
	}
</style>