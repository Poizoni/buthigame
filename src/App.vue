<template>
	<div class="container">
		<ButhiHeader :genus=genus :species=species :subspecies=subspecies />
		<div class="main-screen">
			<ButhiToolbar :score=score :acc=acc :totalQuestions=totalQuestions />
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
				map_url_base: "https://maps.google.com/?q=",
				apiResult: undefined,
				query: "",

				anyOn: false,
				dateSwitchOn: false,
				userSwitchOn: false,

				score: 0,
				totalQuestions: 0,
				acc: 0,

				isStarted: false,
				isLoading: false,
				isInvalid: false,
				onStart: 0,

				genus: "Genus",
				species: "species",
				subspecies: undefined,

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

				firstMap: "",
				secondMap: "",
				thirdMap: "",
				fourthMap: "",

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

					this.updateMaps();
				} else {
					this.timesExecuted = 0;
					this.warn();
				}
			},
			updateMaps() {
				this.firstMap = this.map_url_base + this.apiResult[0].results[this.firstPageNum].location;
				this.secondMap = this.map_url_base + this.apiResult[1].results[this.secondPageNum].location;
				this.thirdMap = this.map_url_base + this.apiResult[2].results[this.thirdPageNum].location;
				this.fourthMap = this.map_url_base + this.apiResult[3].results[this.fourthPageNum].location;
			},
			nextClick() {
			this.setPages();
			this.fetchScorpions();

			if (this.apiResult !== undefined) {
				this.subspecies = undefined;
				this.hideNames();
				this.changePic();
				this.setNames();
				var guess = this.getOneName();
				this.genus = guess.split(" ")[0];
				this.species = guess.split(" ")[1];
				if (guess.split(" ").length > 2) {
				this.subspecies = guess.split(" ")[2];
				}
				this.showMaps();

				this.firstWin = false;
				this.secondWin = false;
				this.thirdWin = false;
				this.fourthWin = false;

				this.firstLose = false;
				this.secondLose = false;
				this.thirdLose = false;
				this.fourthLose = false;

				this.isDisabled = false;
			}
			},
			randomPage() {
			return Math.floor(Math.random() * this.pageCount) + 1;
			},
			async fetchScorpions() {
			if (this.onStart === 0) this.isLoading = true;
			Promise.all([
				await fetch(
				`${
					this.url_base
				}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
					this.query
				}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
					this.perpage
				}`
				),
				await fetch(
				`${
					this.url_base
				}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
					this.query
				}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
					this.perpage
				}`
				),
				await fetch(
				`${
					this.url_base
				}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
					this.query
				}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
					this.perpage
				}`
				),
				await fetch(
				`${
					this.url_base
				}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
					this.query
				}&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
					this.perpage
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
				this.setResults(response);
				if (this.onStart === 0) this.isLoading = false;
				this.onStart = 1;
				})
				.catch((err) => {
				console.error("error", err);
				});
			},
			async setPages() {
			await fetch(
				`${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${this.query}&place_id=&order_by=votes&quality_grade=research&page=1&per_page=1`
			)
				.then((response) => response.json())
				.then((data) => {
				if (data.total_results < 10) {
					this.isInvalid = true;
				}
				if (Math.round(data.total_results / this.perpage) > 1000) {
					this.pageCount = 1000;
				} else {
					this.pageCount = Math.round(
					data.total_results / this.perpage
					);
				}

				if (this.pageCount === 0) {
					this.isInvalid = true;
				}
				})
				.catch((error) => {
				console.error("error" + error);
				});
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
			incQuestions() {
				this.totalQuestions++;
			},
			calcAcc() {
				this.acc = Math.round(((this.score / this.totalQuestions) * 100) * 100) / 100;
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
			showMaps() {
				this.$options.mainInterface.showMaps();
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
			showMaps: () => {},
		},
	};
</script>


<style lang="scss">
	@import "@/assets/global.scss";

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
