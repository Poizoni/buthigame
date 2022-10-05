<template>
	<div class="header">
		<h1 class="title" id="left">ButhiGame</h1>
		<div id="center">
			<h2 class="genus">{{ genus }}</h2>
			<h2 class="species">{{ species }} {{ subspecies }}</h2>
		</div>
		<h3 class="location" id="right">{{ location }}</h3>
	</div>
</template>

<script>
	export default {
		name: "ButhiHeader",
		props: {
			genus: String,
			species: String,
			subspecies: String,
			location: String,
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
		}
		#right {
			text-align: end;
		}
		#center {
			text-align: center;
		}
	}

	@media (max-width: 960px) {
		#center {
			margin-right: 6px;
			margin-left: 6px;
		}
	}
</style>