<template>
      <div class="container">

        <div class="header">
          <h1 class="title">IDer</h1>
          <div>
            <h2 class="species">{{ species }}</h2>
            <h2 class="genus">{{ genus }}</h2>
          </div>
          <h3 class="location">{{ location }}</h3>
        </div>

        <div class="main-screen">

          <div class="toolbar">
            <div class="tools">
              <button class="tool">Hint</button>
              <button class="tool" @click=" nextClick() ">Next</button>
            </div>
            <div class="score-box">
              <p class="score">Score {{ score }}</p>
            </div>
          </div>

          <div class="body">
            <div class="row1">
              <div class="grid">
                <img v-bind:src=first alt="">
                <button @click=" showNames(); firstClick(); " class="btn"  :class="{ win: firstWin, lose: firstLose, disabled: isDisabled }">
                  <span v-if="showingnames">{{ firstname }}</span>
                </button>
              </div>
              <div class="grid">
                <img v-bind:src=second alt="">
                <button @click=" showNames(); secondClick(); " class="btn" :class="{ win:secondWin, lose: secondLose, disabled: isDisabled }"><span v-if="showingnames">{{ secondname }}</span></button>
              </div>
            </div>
            <div class="row2">
              <div class="grid">
                <img v-bind:src=third alt="">
                <button @click=" showNames(); thirdClick(); " class="btn" :class="{ win:thirdWin, lose: thirdLose, disabled: isDisabled }"><span v-if="showingnames">{{ thirdname }}</span></button>
              </div>
              <div class="grid">
                <img v-bind:src=fourth alt="">
                <button @click=" showNames(); fourthClick(); " class="btn" :class="{ win: fourthWin, lose: fourthLose, disabled: isDisabled }"><span v-if="showingnames">{{ fourthname }}</span></button>
              </div>
            </div>
          </div>
        </div>
      </div>
</template>

<script>
  export default {
  name: 'App',
  data () {
    return {
      api_key: '',
      url_base: 'https://api.inaturalist.org/v1/',
      query: '119058',
      scorpion: {},
      score: 0,
      first: 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Scorpion_Photograph_By_Shantanu_Kuveskar.jpg',
      second: 'https://cdn.britannica.com/24/92724-050-54648BED/Scorpion.jpg?w=400&h=300&c=crop',
      third: 'http://cen.acs.org/content/dam/cen/96/web/20180810lnp1-scorpion.jpg',
      fourth: 'https://res.cloudinary.com/roundglass/image/upload/ar_4:3,c_fill,f_auto,g_face,q_auto/c_limit,w_auto:breakpoints_767_2560_30_5:840/v1574433524/roundglass/sustain/Scorpio2_pzasch.jpg',
      firstname: 'Hemiscorpius lepturus',
      secondname: 'Rhopalurus junceus',
      thirdname: 'Parabuthus villosus',
      fourthname: 'Androctonus australis',
      showingnames: false,
      names: [],
      location: 'location',
      species: 'Species',
      genus: 'genus',

      firstWin: false,
      secondWin: false,
      thirdWin: false,
      fourthWin: false,

      firstLose: false,
      secondLose: false,
      thirdLose: false,
      fourthLose: false,

      isDisabled: false,

      page: 1,
      perpage: 30
    }
  },
  methods: {
    nextClick () {
      this.hideNames();
      this.changePic();
      this.populateNames();
      var guess = this.getOneName();
      this.species = guess.split(' ')[0];
      this.genus = guess.split(' ')[1];

      this.firstWin = false;
      this.secondWin = false;
      this.thirdWin = false;
      this.fourthWin = false;

      this.firstLose = false;
      this.secondLose = false;
      this.thirdLose = false;
      this.fourthLose = false;

      this.isDisabled = false;

    },
    populateNames () {
      this.names[0] = this.firstname;
      this.names[1] = this.secondname;
      this.names[2] = this.thirdname;
      this.names[3] = this.fourthname;
    },
    getOneName () {
      var randomNum = Math.floor(Math.random()*4);
      console.log(this.names[randomNum]);
      return this.names[randomNum];
    },
    firstClick () {
      this.isDisabled = true;
      if(this.firstname == (this.species + ' ' + this.genus)) {
        this.setScore();
        this.firstWin = true;
      } else {
        this.firstLose = true;
      }
      this.showNames();
    },
    secondClick () {
      this.isDisabled = true;
      if(this.secondname == (this.species + ' ' + this.genus)) {
        this.setScore();
        this.secondWin = true;
      } else {
        this.secondLose = true;
      }
      this.showNames();
    },
    thirdClick () {
      this.isDisabled = true;
      if(this.thirdname == (this.species + ' ' + this.genus)) {
        this.setScore();
        this.thirdWin = true;
      } else {
        this.thirdLose = true;
      }
      this.showNames();
    },
    fourthClick () {
      this.isDisabled = true;
      if(this.fourthname == (this.species + ' ' + this.genus)) {
        this.setScore();
        this.fourthWin = true;
      } else {
        this.fourthLose = true;
      }
      this.showNames();
    },
    showNames () {
      this.showingnames = true;
    },
    hideNames () {
      this.showingnames = false;
    },
    setScore (score) {
      this.score++
      return score;
    },
    setResults (results) {
      this.scorpion = results;
    },
    randomPage () {
      this.page = Math.floor(Math.random()*200);
      console.log(this.page);
    },
    randomPageObsNum() {
      return Math.floor(Math.random()*30);
    },
    fetchScorpions () {
      Promise.all([
      fetch(`${this.url_base}observations?verifiable=true&taxon_id=${this.query}&place_id=&order_by=votes&quality_grade=any&page=${this.page}&per_page=${this.perpage}`),
      fetch(`${this.url_base}observations?verifiable=true&taxon_id=${this.query}&place_id=&order_by=votes&quality_grade=any&page=${this.page}&per_page=${this.perpage}`),
      fetch(`${this.url_base}observations?verifiable=true&taxon_id=${this.query}&place_id=&order_by=votes&quality_grade=any&page=${this.page}&per_page=${this.perpage}`),
      fetch(`${this.url_base}observations?verifiable=true&taxon_id=${this.query}&place_id=&order_by=votes&quality_grade=any&page=${this.page}&per_page=${this.perpage}`)
      ]).then(function (responses) {
        return Promise.all(responses.map(function (response) {
          return response.json();
        }));
      }).then(
        this.setResults()
        );
        console.log(this.scorpion);
    },
    changePic () {
      this.fetchScorpions()
      this.first = this.scorpion[0][0].url
      this.second = this.scorpion[1][0].url
      this.third = this.scorpion[2][0].url
      this.fourth = this.scorpion[3][0].url
    }
    }
  }
</script>


<style lang="scss">
$dark: #27241d;
$dark2: #423d33;
$dark3: #504a40;
$dark4: #625d52;
$light: #e8e6e1;
$light2: #d3cec4;

body {
  margin: 0;
  padding: 0;
  background-color: $dark;
}

.container {
  display: flex;
  flex-direction: column;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 70%;
  text-align: center;
  padding-left: 20px;
  padding-right: 20px;
  height: 70px;
  background-color: $dark2;
  color: $light2;
  font-family: "Andale Mono", monospace;
}

.main-screen {
  display: flex;
}
.toolbar {
  padding-top: 10px;
  padding-bottom: 50px;
  width: 100px;
  display: flex;
  flex-direction: column-reverse;
  justify-content: space-between;
  background-color: $dark3;
  .tool {
    width: 90%;
    transition: 0.2s;
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
    font-size: 21px;
  }
  .tool:active {
    background-color: $dark4;
  }

  .status {
    height: 10vh;
    background-color: red;
    margin: 8px;
    margin-bottom: 100px;
  }
  .score-box {
    text-align: center;
    font-size: 30px;
    font-family: "Andale Mono", monospace;
    font-weight: bold;
    color: $light2;
    height: 20vh;
    margin-bottom: 60px;
  }
}

.body {
  flex-grow: 1;

  height: auto;
  position: relative;
  display: flex;
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
    height: 40vh;
    align-items: center;
    justify-content: center;

    span {
      border-radius: 4px;
      background-color: $dark3;
      position: absolute;
      top: 83%;
      left: 0;
      font-size: 3vw;
      color: $light2;
      font-family: "Andale Mono", monospace;
    }
  }
  img {
    border: none;
    width: 100%;
    height: auto;
    max-width: 100%;
    max-height: 100%;
    object-fit: cover;
  }
  .btn {
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
    border-radius: 3px;
    transition: 0.3s;
  }
  .btn:hover {
    outline: 15px solid $dark3;

  }
  .btn:active {
    outline: none;
    outline: 2px solid $dark3;
  }
  .lose {
      background-color: rgba(255, 0, 0, 0.4);
    }
    .win {
      background-color: rgba(0, 255, 0, 0.4);
    }
    .disabled {
      pointer-events: none;
    }
}

</style>
