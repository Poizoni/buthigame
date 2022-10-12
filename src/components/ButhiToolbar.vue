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
				<div class="tool load" v-if=" $parent.isLoading ">
					<div class="spinner"></div>
				</div>
				<button class="tool" @click=" start() " v-if=" !$parent.isStarted && !$parent.isLoading ">Start</button>
				<button class="tool" @click=" nextClick() " v-if=" $parent.isStarted && !$parent.isLoading">Next</button>
			</div>
		</div>
		<div class="score-box">
			<h2 class="score" id="bot"><sup>{{ score }}</sup>&frasl;<sub>{{ totalQuestions }}</sub></h2>
			<h2 class="score" id="top">{{ acc }}%</h2>
		</div>
	</div>
</template>

<script>
	export default {
	name: "ButhiToolbar",
	props: {
		score: Number,
		totalQuestions: Number,
		acc: Number,
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
		this.$parent.isStarted = true;
		this.$parent.nextClick();
		},
		nextClick() {
			this.$parent.nextClick();
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

	.score-box {
		text-align: center;
		color: $light2;
		font-family: "Andale Mono", monospace;
		background-color: $dark2;
		border-radius: 10px;
		margin: 5px;
		padding: 3px;
		box-shadow: rgba(0, 0, 0, 0.07) 0px 1px 2px, rgba(0, 0, 0, 0.07) 0px 2px 4px, rgba(0, 0, 0, 0.07) 0px 4px 8px, rgba(0, 0, 0, 0.07) 0px 8px 16px, rgba(0, 0, 0, 0.07) 0px 16px 32px, rgba(0, 0, 0, 0.07) 0px 32px 64px;
		#top {
			margin-bottom: 0;
		}
		#bot {
			margin-top: 5px;
			font-size: 25px;
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
		width: 20vw;
		padding: 0;
		height: 40px;
		}
		.toggles {
		display: flex;
		flex-direction: column;
		margin-bottom: 5px;
		}
		.buttons {
		display: flex;
		flex-direction: column;

		width: 20vw;
		margin-right: 8px;

		}
		.score-box {
		display: flex;
		margin: 0;
		padding: 10px;
		font-size: 50px;
		align-items: center;
			#top {
				font-size: 40px;
				margin: 0;
			}
			#bot {
				margin: 0;
				font-size: 40px;
				margin-right: 40px;

			}
		}
	}
	}
</style>