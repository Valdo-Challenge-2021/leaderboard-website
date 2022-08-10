# Leaderboard website

Small builder based on make and python to build the leaderboard of the challenge.

## Requirements

- Python >=3.6
- GNU make
- Pandas library

## Usage

- Clone this repository:
```bash
git clone --recurse-submodules git@github.com:Valdo-Challenge-2021/leaderboard-website.git
```

- Create the data folder:
```bash
cp -r resources/data_template/ data
```

- Generate the leaderboard:
```
make generate
```

## Authors

- [Carole Sudre](https://github.com/csudre)
- [Kim van Wijnen](https://github.com/kimvwijnen)
- [Robin Camarasa](https://github.com/RobinCamarasa)
