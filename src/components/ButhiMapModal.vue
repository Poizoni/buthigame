<template>
	<div class="modal" v-if="showMap">
		<div class="modal__backdrop" @click=" closeMapModal() " />
		<div class="modal__dialog">
			<div class="modal__body">
				
				<div id="mapid2"></div>
				<!-- <button id="load" v-if="showingLoad" @click=" drawMap(); disableLoad(); ">load map</button> -->

			</div>
		</div>
	</div>
</template>

<script>
	import leaflet from "leaflet";

	export default {
		name: "ButhiMapModal",
		mounted() {
		this.emitInterface();
		},
		data() {
		return {
			showMap: false,
			mymap: null,
			showingLoad: true,
		};
	},
		props: {
			lat: Number,
			lon: Number,
		},
		methods: {
			drawMap() {
				this.mymap = leaflet.map('mapid2').setView([this.lat, this.lon], 3);

						leaflet.tileLayer('https://maptiles.p.rapidapi.com/en/map/v1/{z}/{x}/{y}.png?rapidapi-key=48e65ce7aamsh5ad933f73f2a300p181f25jsnb47613b3dbc9', {
							maxZoom: 15
						}).addTo(this.mymap);

						var greenIcon = new leaflet.Icon({
							iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
							shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
							iconSize: [25, 41],
							iconAnchor: [12, 41],
							shadowSize: [41, 41]
							});

				leaflet.marker([this.lat, this.lon], {icon: greenIcon}).addTo(this.mymap);
			},
			disableLoad() {
				this.showingLoad = false;
			},
			enableLoad() {
				this.showingLoad = true;
			},
			closeMapModal() {
			this.showMap = false;
			this.enableLoad();
			document.querySelector("body").classList.remove("overflow-hidden");
			},
			openMapModal() {
			this.showMap = true;
			document.querySelector("body").classList.add("overflow-hidden");
			},
			emitInterface() {
			this.$emit("interface", {
				openMapModal: () => this.openMapModal(),
				drawMap: () => this.drawMap(),
			});
			},
		}
	}
</script>

<style lang="scss" scoped>
	@import "@/assets/global.scss";

	#mapid2 {
		width: calc(100% - 20px);
		height: 50vh;
		border: 10px solid $dark2;
		border-radius: 10px;
		margin-bottom: 10px;
		margin-top: 10px;

	}
	#load {
		width: 20%;
		transition: 0.02s;

		font-family: "Andale Mono", monospace;
		font-weight: bold;
		color: $dark2;
		height: 10%;
		border-radius: 25px;
		background-color: $light2;
		font-size: 15px;
		border: none;
		align-self: center;
		margin-top: 8px;
		position: absolute;
		
		margin: auto auto;
		left: 0;
		right: 0;
		top: 0;
		bottom: 0;

	}
	#load:hover {
		border: 2px solid $dark4;
	}
	#load:active {
		border: 5px solid $dark4;
	}

.modal {
position: fixed;
top: 0;
right: 0;
bottom: 0;
left: 0;
z-index: 9;
overflow-x: hidden;
overflow-y: auto;
&__backdrop {
	position: fixed;
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	background-color: rgba(0, 0, 0, 0.3);
	z-index: 1;
}
&__dialog {
	position: relative;
	width: 600px;
	background-color: $dark4;
	color: $light2;
	font-family: "Andale Mono", monospace;
	border-radius: 5px;
	margin: 50px auto;
	display: flex;
	flex-direction: column;
	z-index: 2;
	@media screen and (max-width: 992px) {
	width: 90%;
	}
}
&__close {
	width: 30px;
	height: 30px;
	background-color: $light2;
	border: none;
	border-radius: 4px;
	transition: 0.1s;
}
&__close:hover {
	border: 2px solid $dark4;
}
&__close:active {
	border: 4px solid $dark4;
}

&__header {
	font-size: 40px;
	display: flex;
	align-items: flex-end;
	justify-content: flex-end;
	padding: 20px 20px 10px;
}
&__body {
	font-size: 19px;
	padding: 10px 20px 10px;
	overflow: auto;
	display: flex;
	flex-direction: column;
	align-items: stretch;
	li {
	margin: 10px 0;
	}
}
&__footer {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 10px 20px 20px;
}
}
.fade-enter-active,
.fade-leave-active {
transition: opacity 0.2s;
}
.fade-enter,
.fade-leave-to {
opacity: 0;
}
</style>