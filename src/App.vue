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
	<ButhiMapModal	@interface="getMapInterface" :lat=lat :lon=lon />
</template>

<script>
	import ButhiHeader from "./components/ButhiHeader.vue";
	import ButhiToolbar from "./components/ButhiToolbar.vue";
	import ButhiWarnModal from "./components/ButhiWarnModal.vue";
	import ButhiGuideModal from "./components/ButhiGuideModal.vue";
	import ButhiMapModal from "./components/ButhiMapModal.vue";
	import ButhiMain from "./components/ButhiMain.vue";

	export default {
		name: "App",
		components: {
			ButhiHeader,
			ButhiToolbar,
			ButhiWarnModal,
			ButhiGuideModal,
			ButhiMapModal,
			ButhiMain,
		},
		data() {
			return {
				url_base: "https://api.inaturalist.org/v1/",
				apiResult: undefined,
				orderResult: undefined,
				query: "",

				anyOn: false,
				dateSwitchOn: false,
				userSwitchOn: false,
				orderSwitchOn: false,
				familySwitchOn: false,

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

				firstOrder: "",
				secondOrder: "",
				thirdOrder: "",
				fourthOrder: "",

				firstFamily: "",
				secondFamily: "",
				thirdFamily: "",
				fourthFamily: "",

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
				
				firstCoords: [],
				secondCoords: [],
				thirdCoords: [],
				fourthCoords: [],

				perpage: 10,
				pageCount: 1,

				timesExecuted: 0,
				isDisabled: true,
				lat: 0,
				lon: 0,
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

					if(this.orderSwitchOn) {
						this.setOrders();
						
						this.firstname = this.firstOrder;
						this.secondname = this.secondOrder;
						this.thirdname = this.thirdOrder;
						this.fourthname = this.fourthOrder;
					}
					if(this.familySwitchOn) {
						this.setFamilies();
						
						this.firstname = this.firstFamily;
						this.secondname = this.secondFamily;
						this.thirdname = this.thirdFamily;
						this.fourthname = this.fourthFamily;
					}


					this.updateCoords();
				} else {
					this.timesExecuted = 0;
					this.warn();
				}
			},
			updateCoords() {
				var str1 = this.apiResult[0].results[this.firstPageNum].location;
				str1 = str1.replace(/,/g, " ")
				this.firstCoords = str1.split(' ');

				var str2 = this.apiResult[1].results[this.secondPageNum].location;
				str2 = str2.replace(/,/g, " ")
				this.secondCoords = str2.split(' ');

				var str3 = this.apiResult[2].results[this.thirdPageNum].location;
				str3 = str3.replace(/,/g, " ")
				this.thirdCoords = str3.split(' ');

				var str4 = this.apiResult[3].results[this.fourthPageNum].location;
				str4 = str4.replace(/,/g, " ")
				this.fourthCoords = str4.split(' ');

			},
			nextClick() {
			this.setPages();
			this.fetchScorpions();

			if (this.apiResult !== undefined) {
				console.log(this.apiResult);
				this.subspecies = undefined;
				this.species = undefined;
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
			setOrders() {
				for(var i = 0; i < this.apiResult[0].results[this.firstPageNum].identifications.length; i++) {
					if (this.apiResult[0].results[this.firstPageNum].identifications[i].category == "supporting")  {
						for(var k = 0; k < this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors.length; k++) {
							if (this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors[k].rank == "order")  {
								this.firstOrder = this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors[k].name
								break;
							}
				}

					}
				}

				for(var j = 0; j < this.apiResult[1].results[this.secondPageNum].identifications.length; j++) {
					if (this.apiResult[1].results[this.secondPageNum].identifications[j].category == "supporting")  {
						for(var h = 0; h < this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors.length; h++) {
							if (this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors[h].rank == "order")  {
								this.secondOrder = this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors[h].name
								break;
							}
				}

					}
				}

				for(var f = 0; f < this.apiResult[2].results[this.thirdPageNum].identifications.length; f++) {
					if (this.apiResult[2].results[this.thirdPageNum].identifications[f].category == "supporting")  {
						for(var r = 0; r < this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors.length; r++) {
							if (this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors[r].rank == "order")  {
								this.thirdOrder = this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors[r].name
								break;
							}
				}

					}
				}

				for(var x = 0; x < this.apiResult[3].results[this.fourthPageNum].identifications.length; x++) {
					if (this.apiResult[3].results[this.fourthPageNum].identifications[x].category == "supporting")  {
						for(var y = 0; y < this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors.length; y++) {
							if (this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors[y].rank == "order")  {

								this.fourthOrder = this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors[y].name
								break;
							}
				}

					}
				}
			},
			setFamilies() {
				for(var i = 0; i < this.apiResult[0].results[this.firstPageNum].identifications.length; i++) {
					if (this.apiResult[0].results[this.firstPageNum].identifications[i].category == "supporting")  {
						for(var k = 0; k < this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors.length; k++) {
							if (this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors[k].rank == "family")  {
								this.firstFamily = this.apiResult[0].results[this.firstPageNum].identifications[i].taxon.ancestors[k].name
								break;
							}
				}

					}
				}

				for(var j = 0; j < this.apiResult[1].results[this.secondPageNum].identifications.length; j++) {
					if (this.apiResult[1].results[this.secondPageNum].identifications[j].category == "supporting")  {
						for(var h = 0; h < this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors.length; h++) {
							if (this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors[h].rank == "family")  {
								this.secondFamily = this.apiResult[1].results[this.secondPageNum].identifications[j].taxon.ancestors[h].name
								break;
							}
				}

					}
				}

				for(var f = 0; f < this.apiResult[2].results[this.thirdPageNum].identifications.length; f++) {
					if (this.apiResult[2].results[this.thirdPageNum].identifications[f].category == "supporting")  {
						for(var r = 0; r < this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors.length; r++) {
							if (this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors[r].rank == "family")  {
								this.thirdFamily = this.apiResult[2].results[this.thirdPageNum].identifications[f].taxon.ancestors[r].name
								break;
							}
				}

					}
				}

				for(var x = 0; x < this.apiResult[3].results[this.fourthPageNum].identifications.length; x++) {
					if (this.apiResult[3].results[this.fourthPageNum].identifications[x].category == "supporting")  {
						for(var y = 0; y < this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors.length; y++) {
							if (this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors[y].rank == "family")  {

								this.fourthFamily = this.apiResult[3].results[this.fourthPageNum].identifications[x].taxon.ancestors[y].name
								break;
							}
				}

					}
				}
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
			getMapInterface(mapInterface) {
				this.$options.mapInterface = mapInterface;
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
			async openMapModal(selected) {
				switch(selected) {
					case 1:
						this.lat = parseFloat(this.firstCoords[0]);
						this.lon = parseFloat(this.firstCoords[1]);
						await this.$options.mapInterface.openMapModal();
						this.drawMap();
						break;
					case 2:
						this.lat = parseFloat(this.secondCoords[0]);
						this.lon = parseFloat(this.secondCoords[1]);
						await this.$options.mapInterface.openMapModal();
						this.drawMap();
						break;	
					case 3:
						this.lat = parseFloat(this.thirdCoords[0]);
						this.lon = parseFloat(this.thirdCoords[1]);
						await this.$options.mapInterface.openMapModal();
						this.drawMap();
						break;
					case 4:
						this.lat = parseFloat(this.fourthCoords[0]);
						this.lon = parseFloat(this.fourthCoords[1]);
						await this.$options.mapInterface.openMapModal();
						this.drawMap();
						break;
					default:
						console.log("error")
				}
			},
			drawMap() {
					this.$options.mapInterface.drawMap();

			}
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
		mapInterface: {
			openMapModal: () => {},
			drawMap: () => {},
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
