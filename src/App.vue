<template>
	<div class="container">
		<ButhiHeader :genus=genus :species=species :subspecies=subspecies :location=location />
		<div class="main-screen">
			<ButhiToolbar :score=score />
			<ButhiMain @interface="getMainInterface" />
		</div>
	</div>
	<ButhiGuideModal @interface="getGuideInterface" />
	<ButhiWarnModal @interface="getWarnInterface" />
</template>

<script>
	import ButhiHeader from "./components/ButhiHeader.vue";
	import ButhiToolbar from "./components/ButhiToolbar.vue";
	import ButhiWarnModal from "./components/ButhiWarnModal.vue";
	import ButhiGuideModal from "./components/ButhiGuideModal.vue";
	import ButhiMain from "./components/ButhiMain.vue";

	export default {
		name: "App",
		components: {
			ButhiHeader,
			ButhiToolbar,
			ButhiWarnModal,
			ButhiGuideModal,
			ButhiMain,
		},
		data() {
			return {
				url_base: "https://api.inaturalist.org/v1/",
				apiResult: undefined,
				query: "",

				anyOn: false,
				dateSwitchOn: false,
				userSwitchOn: false,

				score: 0,

				genus: "Genus",
				species: "species",
				subspecies: undefined,

				location: "location",

				names: [],

				firstname: "",
				secondname: "",
				thirdname: "",
				fourthname: "",

				first: "https://i.imgur.com/hs8VDXc.jpg",
				second: "https://i.imgur.com/gKFhqMb.jpeg",
				third: "https://i.imgur.com/NQB7xH8.jpg",
				fourth: "https://i.imgur.com/oMWs9ae.jpeg",

				firstDate: "",
				secondDate: "",
				thirdDate: "",
				fourthDate: "",

				firstUser: "",
				secondUser: "",
				thirdUser: "",
				fourthUser: "",

				firstLink: "",
				secondLink: "",
				thirdLink: "",
				fourthLink: "",

				firstWin: false,
				secondWin: false,
				thirdWin: false,
				fourthWin: false,

				firstLose: false,
				secondLose: false,
				thirdLose: false,
				fourthLose: false,

				firstPageNum: 1,
				secondPageNum: 1,
				thirdPageNum: 1,
				fourthPageNum: 1,

				perpage: 10,
				pageCount: 1,

				timesExecuted: 0,
				isDisabled: true,
			};
		},

		methods: {
			changePic() {
				if (this.timesExecuted < 300) {
					this.getRandomPageObsNums();
					this.timesExecuted++;
					this.checkNames();

					var firstLink =
						this.apiResult[0].results[this.firstPageNum].photos[0].url;
					this.first = this.getMedium(firstLink);
					this.firstname =
						this.apiResult[0].results[this.firstPageNum].taxon.name;
					this.firstDate =
						this.apiResult[0].results[this.firstPageNum].observed_on;
					this.firstUser =
						this.apiResult[0].results[this.firstPageNum].user.login;
					this.firstLink = this.apiResult[0].results[this.firstPageNum].uri;

					var secondLink =
						this.apiResult[1].results[this.secondPageNum].photos[0].url;
					this.second = this.getMedium(secondLink);
					this.secondname =
						this.apiResult[1].results[this.secondPageNum].taxon.name;
					this.secondDate =
						this.apiResult[1].results[this.secondPageNum].observed_on;
					this.secondUser =
						this.apiResult[1].results[this.secondPageNum].user.login;
					this.secondLink = this.apiResult[1].results[this.secondPageNum].uri;

					var thirdLink =
						this.apiResult[2].results[this.thirdPageNum].photos[0].url;
					this.third = this.getMedium(thirdLink);
					this.thirdname =
						this.apiResult[2].results[this.thirdPageNum].taxon.name;
					this.thirdDate =
						this.apiResult[2].results[this.thirdPageNum].observed_on;
					this.thirdUser =
						this.apiResult[2].results[this.thirdPageNum].user.login;
					this.thirdLink = this.apiResult[2].results[this.thirdPageNum].uri;

					var fourthLink =
						this.apiResult[3].results[this.fourthPageNum].photos[0].url;
					this.fourth = this.getMedium(fourthLink);
					this.fourthname =
						this.apiResult[3].results[this.fourthPageNum].taxon.name;
					this.fourthDate =
						this.apiResult[3].results[this.fourthPageNum].observed_on;
					this.fourthUser =
						this.apiResult[3].results[this.fourthPageNum].user.login;
					this.fourthLink = this.apiResult[3].results[this.fourthPageNum].uri;
				} else {
					this.timesExecuted = 0;
					this.warn();
				}
			},

			checkNames() {
				if (
					this.apiResult[0].results[this.firstPageNum] === undefined ||
					this.apiResult[1].results[this.secondPageNum] === undefined ||
					this.apiResult[2].results[this.thirdPageNum] === undefined ||
					this.apiResult[3].results[this.fourthPageNum] === undefined
				) {
					return this.changePic();
				}

				var firstTaxa = this.apiResult[0].results[this.firstPageNum].taxon.name;
				var secondTaxa = this.apiResult[1].results[this.secondPageNum].taxon.name;
				var thirdTaxa = this.apiResult[2].results[this.thirdPageNum].taxon.name;
				var fourthTaxa = this.apiResult[3].results[this.fourthPageNum].taxon.name;

				if (
					firstTaxa === secondTaxa ||
					firstTaxa === thirdTaxa ||
					firstTaxa === fourthTaxa ||
					secondTaxa === thirdTaxa ||
					secondTaxa === fourthTaxa ||
					thirdTaxa === fourthTaxa
				) {
					return this.changePic();
				}
			},

			setNames() {
				this.names[0] = this.firstname;
				this.names[1] = this.secondname;
				this.names[2] = this.thirdname;
				this.names[3] = this.fourthname;
			},
			setLocation() {
				if (
					this.getFullName() ===
					this.apiResult[0].results[this.firstPageNum].taxon.name
				)
					this.location =
						this.apiResult[0].results[this.firstPageNum].place_guess;
				if (
					this.getFullName() ===
					this.apiResult[1].results[this.secondPageNum].taxon.name
				)
					this.location =
						this.apiResult[1].results[this.secondPageNum].place_guess;
				if (
					this.getFullName() ===
					this.apiResult[2].results[this.thirdPageNum].taxon.name
				)
					this.location =
						this.apiResult[2].results[this.thirdPageNum].place_guess;
				if (
					this.getFullName() ===
					this.apiResult[3].results[this.fourthPageNum].taxon.name
				)
					this.location =
						this.apiResult[3].results[this.fourthPageNum].place_guess;
			},
			setResults(results) {
				this.apiResult = results;
			},

			getRandomPageObsNums() {
				var randoms = [];
				while (randoms.length < 4) {
					var r = Math.floor(Math.random() * 10) + 1;
					if (randoms.indexOf(r) === -1) randoms.push(r);
				}
				this.firstPageNum = randoms[0];
				this.secondPageNum = randoms[1];
				this.thirdPageNum = randoms[2];
				this.fourthPageNum = randoms[3];
			},
			getOneName() {
				var randomNum = Math.floor(Math.random() * 4);
				return this.names[randomNum];
			},
			getFullName() {
				if (this.species === undefined) {
					return this.genus;
				}
				if (this.subspecies === undefined) {
					return this.genus + " " + this.species;
				} else {
					return this.genus + " " + this.species + " " + this.subspecies;
				}
			},
			getMedium(string) {
				var newString = string.replace("square", "medium");
				return newString;
			},
			getWarnInterface(warnInterface) {
				this.$options.warnInterface = warnInterface;
			},
			getGuideInterface(guideInterface) {
				this.$options.guideInterface = guideInterface;
			},
			getMainInterface(mainInterface) {
				this.$options.mainInterface = mainInterface;
			},

			hideNames() {
				this.$options.mainInterface.hideNames();
			},
			warn() {
				this.$options.warnInterface.openWarnModal();
			},
			openGuideModal() {
				this.$options.guideInterface.openGuideModal();
			},
		},
		warnInterface: {
			openWarnModal: () => {},
		},
		guideInterface: {
			openGuideModal: () => {},
		},
		mainInterface: {
			hideNames: () => {},
		},
	};
</script>


<style lang="scss">
	@import "@/assets/global.scss";
	@import "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css";

	body {
		margin: 0;
		padding: 0;
		min-height: 100vh;
		background-color: $dark;
	}

	.container {
		display: flex;
		flex-direction: column;
	}

	.main-screen {
		display: flex;
	}

	@media (max-width: 960px) {
		.main-screen {
			height: calc(100vh - 70px);
			display: flex;
			flex-direction: column-reverse;
		}
	}
</style>
