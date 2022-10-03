<template>
      <div class="container">

        <div class="header">
          <h1 class="title" id="left">ButhiGame</h1>
          <div id="center">
            <h2 class="genus">{{ genus }}</h2>
            <h2 class="species">{{ species }} {{ subspecies }}</h2>
          </div>
          <h3 class="location" id="right">{{ location }}</h3>
        </div>

        <div class="main-screen">

          <div class="toolbar">
            <div class="tools">

              <div class="toggles">
                <div class="tool switch">
                <p>user</p>
                <div class="toggle off" :class="{ on: userSwitchOn }">
                  <div class="toggle-side toggle-side_off" :class="{ on: userSwitchOn }"></div>
                  <div class="toggle-switch" :class="{ on: userSwitchOn }" @click="userSwitchOn = !userSwitchOn; checkAny();"></div>
                  <div class="toggle-side toggle-side_on" :class="{ on: userSwitchOn }"></div>
                </div>
              </div>

              <div class="tool switch">
                <p>date</p>
                <div class="toggle off" :class="{ on: dateSwitchOn }">
                  <div class="toggle-side toggle-side_off" :class="{ on: dateSwitchOn }"></div>
                  <div class="toggle-switch" :class="{ on: dateSwitchOn }" @click="dateSwitchOn = !dateSwitchOn; checkAny();"></div>
                  <div class="toggle-side toggle-side_on" :class="{ on: dateSwitchOn }"></div>
                </div>
              </div>
              </div>

              <div class="buttons">
                <button class="tool" @click=" openModal() ">Guide</button>
              <div class="tool load" v-if=" isLoading "><div class="spinner"></div></div>
              <button class="tool" @click=" start() " v-if=" !isStarted && !isLoading ">Start</button>
              <button class="tool" @click=" nextClick() " v-if=" isStarted && !isLoading">Next</button>
              </div>
            </div>
            <div class="inputTool">
              <div class="inputToolLeft">
                <label for="input" >taxon</label>
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

          <div class="body">
            <div class="row1">
              <div class="grid">
                <img v-bind:src=first alt="">
                <button @click=" showNames(); firstClick(); " class="btn" :class="{ win: firstWin, lose: firstLose, disabled: isDisabled }">
                  <div v-if="anyOn" class="top">
                    <span v-if="dateSwitchOn">{{ firstDate }}</span>
                    <span v-if="userSwitchOn">{{ firstUser }}</span>
                  </div>
                  <span v-if="showingnames">{{ firstname }}</span>
                </button>
                <div v-if="showingnames" class="out">
                    <a target="_blank" rel="noopener noreferrer" :href="firstLink" class="fa fa-external-link"></a>
                  </div>
              </div>
              <div class="grid">
                <img v-bind:src=second alt="">
                <button @click=" showNames(); secondClick(); " class="btn" :class="{ win:secondWin, lose: secondLose, disabled: isDisabled }">
                  <div v-if="anyOn" class="top">
                    <span v-if="dateSwitchOn">{{ secondDate }}</span>
                    <span v-if="userSwitchOn">{{ secondUser }}</span>
                  </div>
                  <span v-if="showingnames">{{ secondname }}</span>
                </button>
                <div v-if="showingnames" class="out">
                    <a target="_blank" rel="noopener noreferrer" :href="secondLink" class="fa fa-external-link"></a>
                  </div>
              </div>
            </div>
            <div class="row2">
              <div class="grid">
                <img v-bind:src=third alt="">
                <button @click=" showNames(); thirdClick(); " class="btn" :class="{ win:thirdWin, lose: thirdLose, disabled: isDisabled }">
                  <div v-if="anyOn" class="top">
                    <span v-if="dateSwitchOn">{{ thirdDate }}</span>
                    <span v-if="userSwitchOn">{{ thirdUser }}</span>
                  </div>
                  <span v-if="showingnames">{{ thirdname }}</span>
                </button>
                <div v-if="showingnames" class="out">
                    <a target="_blank" rel="noopener noreferrer" :href="thirdLink" class="fa fa-external-link"></a>
                  </div>
              </div>
              <div class="grid">
                <img v-bind:src=fourth alt="">
                <button @click=" showNames(); fourthClick(); " class="btn" :class="{ win: fourthWin, lose: fourthLose, disabled: isDisabled }">
                  <div v-if="anyOn" class="top">
                    <span v-if="dateSwitchOn">{{ fourthDate }}</span>
                    <span v-if="userSwitchOn">{{ fourthUser }}</span>
                  </div>
                  <span v-if="showingnames">{{ fourthname }}</span>
                </button>
                <div v-if="showingnames" class="out">
                    <a target="_blank" rel="noopener noreferrer" :href="fourthLink" class="fa fa-external-link"></a>
                  </div>
              </div>
            </div>
          </div>

        </div>

      </div>
      <div class="modal" v-if="show">
        <div class="modal__backdrop" @click=" closeModal() "/>

        <div class="modal__dialog">

        <div class="modal__body">
          <ul>
            <li>Type any taxa besides species in the input (class, family, genus)</li>
            <li>Click 'get' button and make sure the text says valid</li>
            <li>Start</li>
            <li>Wait for loading to finish, then click next</li>
            <li>If changing taxa mid-game, repeat the step above</li>
            <li>Practice your identification skills and enjoy!</li>
          </ul>
        </div>

        <div class="modal__footer">
          <p>developed by poizoni</p>
          <button type="button" class="modal__close" @click="closeModal()">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 352 512">
              <path
                fill="currentColor"
                d="M242.72 256l100.07-100.07c12.28-12.28 12.28-32.19 0-44.48l-22.24-22.24c-12.28-12.28-32.19-12.28-44.48 0L176 189.28 75.93 89.21c-12.28-12.28-32.19-12.28-44.48 0L9.21 111.45c-12.28 12.28-12.28 32.19 0 44.48L109.28 256 9.21 356.07c-12.28 12.28-12.28 32.19 0 44.48l22.24 22.24c12.28 12.28 32.2 12.28 44.48 0L176 322.72l100.07 100.07c12.28 12.28 32.2 12.28 44.48 0l22.24-22.24c12.28-12.28 12.28-32.19 0-44.48L242.72 256z"
              ></path>
            </svg>
          </button>
        </div>
      </div>
    </div>


      <div class="modal" v-if="showWarn">
        <div class="modal__backdrop" @click=" closeWarnModal() "/>

        <div class="modal__dialog">

        <div class="modal__body">
          WARNING
        </div>

        <div class="modal__footer">
          <p>not many photos available, <br> functionality may be problematic with this taxa</p>
          <button type="button" class="modal__close" @click="closeWarnModal()">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 352 512">
              <path
                fill="currentColor"
                d="M242.72 256l100.07-100.07c12.28-12.28 12.28-32.19 0-44.48l-22.24-22.24c-12.28-12.28-32.19-12.28-44.48 0L176 189.28 75.93 89.21c-12.28-12.28-32.19-12.28-44.48 0L9.21 111.45c-12.28 12.28-12.28 32.19 0 44.48L109.28 256 9.21 356.07c-12.28 12.28-12.28 32.19 0 44.48l22.24 22.24c12.28 12.28 32.2 12.28 44.48 0L176 322.72l100.07 100.07c12.28 12.28 32.2 12.28 44.48 0l22.24-22.24c12.28-12.28 12.28-32.19 0-44.48L242.72 256z"
              ></path>
            </svg>
          </button>
        </div>
      </div>
    </div>
</template>

<script>
  export default {
    name: "App",
    data() {
      return {
        showingDate: false,
        dateSwitchOn: false,
        userSwitchOn: false,
        show: false,
        isLoading: false,
        showWarn: false,
        url_base: "https://api.inaturalist.org/v1/",
        query: "",
        scorpion: undefined,
        score: 0,
        first: "https://i.imgur.com/hs8VDXc.jpg",
        second: "https://i.imgur.com/gKFhqMb.jpeg",
        third: "https://i.imgur.com/NQB7xH8.jpg",
        fourth: "https://i.imgur.com/oMWs9ae.jpeg",
        firstname: "",
        secondname: "",
        thirdname: "",
        fourthname: "",
        showingnames: false,
        names: [],
        location: "location",
        species: "species",
        genus: "Genus",
        subspecies: undefined,
        input: '',

        firstWin: false,
        secondWin: false,
        thirdWin: false,
        fourthWin: false,

        firstLose: false,
        secondLose: false,
        thirdLose: false,
        fourthLose: false,

        firstDate: '',
        secondDate: '',
        thirdDate: '',
        fourthDate: '',

        firstUser: '',
        secondUser: '',
        thirdUser: '',
        fourthUser: '',

        firstLink: '',
        secondLink: '',
        thirdLink: '',
        fourthLink: '',

        isDisabled: true,

        perpage: 10,

        firstPageNum: 1,
        secondPageNum: 1,
        thirdPageNum: 1,
        fourthPageNum: 1,

        isStarted: false,
        isInvalid: false,
        timesExecuted: 0,
        pageCount: 1,
        onStart: 0,
        anyOn: false
            };
    },
    methods: {
      checkAny () {
        if(this.userSwitchOn || this.dateSwitchOn) {
          this.anyOn = true;
        } else {
          this.anyOn = false;
        }
      },
      closeModal() {
      this.show = false;
      document.querySelector("body").classList.remove("overflow-hidden");
    },
    openModal() {
      this.show = true;
      document.querySelector("body").classList.add("overflow-hidden");
    },
    closeWarnModal() {
      this.showWarn = false;
      document.querySelector("body").classList.remove("overflow-hidden");
    },
    openWarnModal() {
      this.showWarn = true;
      document.querySelector("body").classList.add("overflow-hidden");
    },
      start() {
        this.isStarted = true;
        this.nextClick();
      },
      nextClick() {
        this.setPages();
        this.fetchScorpions();

        if (this.scorpion !== undefined) {
          this.subspecies = undefined;
          this.hideNames();
          this.changePic();
          this.populateNames();
          var guess = this.getOneName();
          this.genus = guess.split(" ")[0];
          this.species = guess.split(" ")[1];
          if(guess.split(' ').length > 2) {
            this.subspecies = guess.split(" ")[2];
          }
          this.setLocation();

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
      changePic() {
        if(this.timesExecuted < 300) {
        this.randomPageObsNums();
        this.timesExecuted++;
        this.checkNames();

        var firstLink = 
          this.scorpion[0].results[this.firstPageNum].photos[0].url;
          this.first = this.getMedium(firstLink);
          this.firstname = this.scorpion[0].results[this.firstPageNum].taxon.name;
          this.firstDate = this.scorpion[0].results[this.firstPageNum].observed_on;
          this.firstUser = this.scorpion[0].results[this.firstPageNum].user.login;
          this.firstLink = this.scorpion[0].results[this.firstPageNum].uri;
          console.log(this.scorpion[0].results[this.firstPageNum].uri);

        var secondLink =
          this.scorpion[1].results[this.secondPageNum].photos[0].url;
          this.second = this.getMedium(secondLink);
          this.secondname = this.scorpion[1].results[this.secondPageNum].taxon.name;
          this.secondDate = this.scorpion[1].results[this.secondPageNum].observed_on;
          this.secondUser = this.scorpion[1].results[this.secondPageNum].user.login;
          this.secondLink = this.scorpion[1].results[this.secondPageNum].uri;

        var thirdLink = 
          this.scorpion[2].results[this.thirdPageNum].photos[0].url;
          this.third = this.getMedium(thirdLink);
          this.thirdname = this.scorpion[2].results[this.thirdPageNum].taxon.name;
          this.thirdDate = this.scorpion[2].results[this.thirdPageNum].observed_on;
          this.thirdUser = this.scorpion[2].results[this.thirdPageNum].user.login;
          this.thirdLink = this.scorpion[2].results[this.thirdPageNum].uri;

        var fourthLink =
          this.scorpion[3].results[this.fourthPageNum].photos[0].url;
          this.fourth = this.getMedium(fourthLink);
          this.fourthname = this.scorpion[3].results[this.fourthPageNum].taxon.name;
          this.fourthDate = this.scorpion[3].results[this.fourthPageNum].observed_on;
          this.fourthUser = this.scorpion[3].results[this.fourthPageNum].user.login;
          this.fourthLink = this.scorpion[3].results[this.fourthPageNum].uri;
        } else {
          this.timesExecuted = 0;
          this.openWarnModal();
        }
      },
      checkNames() {
        if (
          this.scorpion[0].results[this.firstPageNum] === undefined ||
          this.scorpion[1].results[this.secondPageNum] === undefined ||
          this.scorpion[2].results[this.thirdPageNum] === undefined ||
          this.scorpion[3].results[this.fourthPageNum] === undefined
        ) {
          return this.changePic();
        }

        var firstTaxa = this.scorpion[0].results[this.firstPageNum].taxon.name;
        var secondTaxa = this.scorpion[1].results[this.secondPageNum].taxon.name;
        var thirdTaxa = this.scorpion[2].results[this.thirdPageNum].taxon.name;
        var fourthTaxa = this.scorpion[3].results[this.fourthPageNum].taxon.name;

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
      async fetchScorpions() {
        if(this.onStart === 0)
          this.isLoading = true;
        Promise.all([
          await fetch(
            `${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
              this.query
            }&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
              this.perpage
            }`
          ),
          await fetch(
            `${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
              this.query
            }&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
              this.perpage
            }`
          ),
          await fetch(
            `${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
              this.query
            }&place_id=&order_by=votes&quality_grade=research&page=${this.randomPage()}&per_page=${
              this.perpage
            }`
          ),
          await fetch(
            `${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
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
            this.setResults(response)
              if(this.onStart === 0)
                this.isLoading = false;
              this.onStart = 1;
          })
          .catch((err) => {
            console.error("error", err)
          });
      },
      populateNames() {
        this.names[0] = this.firstname;
        this.names[1] = this.secondname;
        this.names[2] = this.thirdname;
        this.names[3] = this.fourthname;
      },
      setLocation() {
        if((this.getFullName()) === this.scorpion[0].results[this.firstPageNum].taxon.name) 
          this.location = this.scorpion[0].results[this.firstPageNum].place_guess;
        if((this.getFullName()) === this.scorpion[1].results[this.secondPageNum].taxon.name) 
          this.location = this.scorpion[1].results[this.secondPageNum].place_guess;
        if((this.getFullName()) === this.scorpion[2].results[this.thirdPageNum].taxon.name) 
          this.location = this.scorpion[2].results[this.thirdPageNum].place_guess;
        if((this.getFullName()) === this.scorpion[3].results[this.fourthPageNum].taxon.name) 
          this.location = this.scorpion[3].results[this.fourthPageNum].place_guess;
      },
      getOneName() {
        var randomNum = Math.floor(Math.random() * 4);
        return this.names[randomNum];
      },
      getFullName () {
        if(this.species === undefined) {
          return this.genus;
        }
        if(this.subspecies === undefined) {
          return (this.genus + " " + this.species);
        }
        else {
          return (this.genus + " " + this.species + " " + this.subspecies);
        }
      },
      firstClick() {
        this.isDisabled = true;
        if (this.firstname === this.getFullName()) {
          this.setScore();
          this.firstWin = true;
        } else {
          this.firstLose = true;
        }
        this.showNames();
      },
      secondClick() {
        this.isDisabled = true;
        if (this.secondname === this.getFullName()) {
          this.setScore();
          this.secondWin = true;
        } else {
          this.secondLose = true;
        }
        this.showNames();
      },
      thirdClick() {
        this.isDisabled = true;
        if (this.thirdname === this.getFullName()) {
          this.setScore();
          this.thirdWin = true;
        } else {
          this.thirdLose = true;
        }
        this.showNames();
      },
      fourthClick() {
        this.isDisabled = true;
        if (this.fourthname === this.getFullName()) {
          this.setScore();
          this.fourthWin = true;
        } else {
          this.fourthLose = true;
        }
        this.showNames();
      },
      showNames() {
        this.showingnames = true;
      },
      hideNames() {
        this.showingnames = false;
      },
      setScore(score) {
        this.score++;
        return score;
      },
      setResults(results) {
        this.scorpion = results;
      },
      randomPage() {
        return Math.floor(Math.random() * this.pageCount) + 1;
      },
      randomPageObsNums() {
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
      getMedium(string) {
        var newString = string.replace("square", "medium");
        return newString;
      },
      async checkInput () {
        this.scorpion = undefined;
        this.isLoading = true;

        await fetch(`https://api.inaturalist.org/v1/taxa?q=${this.input}&is_active=any&per_page=1`)
        .then((response) => response.json())
        .then((data) => {
          this.setQuery(data)
          this.isLoading = false;
          this.onStart = 0;
        })
        .catch((error) => {
          console.error('eror' + error);
          this.isInvalid = true;
        });

        this.setPages();
      },
      async setPages () {
        await fetch(`${this.url_base}observations?verifiable=true&photos=true&?hrank=species?lrank=species&taxon_id=${
              this.query
            }&place_id=&order_by=votes&quality_grade=research&page=1&per_page=1`)
        .then((response) => response.json())
        .then((data) => {
            if(data.total_results < 10) {
              this.isInvalid = true;
            }
            if(Math.round(data.total_results / this.perpage) > 1000) {
              this.pageCount = 1000;
            } else{
              this.pageCount = Math.round(data.total_results / this.perpage)
            }
            if(this.pageCount === 0) {
              this.isInvalid = true;
            }
      })
      .catch((error) => {
        console.error('error' + error);
      });
      },
      setQuery (data) {
        try {
        this.query = data.results[0].id;
        this.isInvalid = false;
      }
        catch (err) {
          this.isInvalid = true;
          console.error('error' + err);
        }
      }
    },
    beforeMount() {
    },
  };
</script>


<style lang="scss">
  @import 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css';

  $dark: #27241d;
  $dark2: #423d33;
  $dark3: #504a40;
  $dark4: #625d52;
  $light: #e8e6e1;
  $light2: #d3cec4;
  
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

  .main-screen {
    display: flex;
  }
  @media (max-width:960px) {
      #center {
        margin-right: 6px;
        margin-left: 6px;

      }
    .main-screen {
      height: calc(100vh - 70px);
    display: flex;
      flex-direction: column-reverse;
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
      .row1, .row2 {
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
    }
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
        height: 30px;
        width: 30px;
        animation: rotation .5s infinite linear;
        border-left: 3px solid rgba(66, 61, 51, .15);
        border-right: 3px solid rgba(66, 61, 51, .15);
        border-bottom: 3px solid rgba(66, 61, 51, .15);
        border-top: 3px solid rgba(66, 61, 51, .8);
        border-radius: 100%;
      }

      @keyframes rotation {
        from {transform: rotate(0deg);}
        to {transform: rotate(359deg);}
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
  
  .toggle-side, .toggle-switch {
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
      box-shadow: 0 0 1px rgba(0,0,0,.7);
      top: -2px;
      left: 0;
      transition: transform .1s, left 0.3s;
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
      border:none;
    }
    .switch:active {
      border:none;
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
          padding: 4px;
          color: $light2;
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
