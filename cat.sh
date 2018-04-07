#!/bin/bash

WORKDIR=$(pwd)

###########################
#### Download cat photo
cd catload
PHOTO_NAME=$(node get_cat_photo.js)
CAT_PHOTO_PATH=$WORKDIR/catload/$PHOTO_NAME
echo "Download photo: "$CAT_PHOTO_PATH
cd ..

HTTP_FOLDER_PATH='https://api.algorithmia.com/v1/connector/data/.my/'
CAT_SERVER_PATH='neuralcat/cat.jpg'
STYLED_CAT_NAME='styled_cat.jpg'
STYLED_CAT_PATH='neuralcat/'$STYLED_CAT_NAME

###########################
#### Link with filters: https://algorithmia.com/algorithms/deeplearning/DeepFilter/docs
STYLES=(
    "alien_goggles" "aqua" "blue_brush" "blue_granite" "bright_sand" \
    "cinnamon_rolls" "clean_view" "colorful_blocks" "colorful_dream" \
    "crafty_painting" "creativity" "crunch_paper" "dark_rain" "dark_soul" \
    "deep_connections" "dry_skin" "far_away" "green_zuma" \
    "hot_spicy" "neo_instinct" "oily_mcoilface" "plentiful" "post_modern" \
    "purp_paper" "purple_pond" "purple_storm" "rainbow_festival" "really_hot" \
    "space_pizza" "gan_vogh" "really_hot" "sand_paper" "smooth_ride" \
    "spagetti_accident" "sunday" "yellow_collage" "yellow_paper"
)

RANDOMSEED=$$$(date +%s)

RANDOMSTYLE=${STYLES[$RANDOMSEED % ${#STYLES[@]} ]}
echo "Chosen style: "$RANDOMSTYLE

###########################
#### Upload photo to style
curl -X PUT -H 'Authorization: Simple '$ALGORITHMIA_TOKEN \
    --data-binary @$CAT_PHOTO_PATH \
    $HTTP_FOLDER_PATH$CAT_SERVER_PATH

###########################
#### Call styler API
curl -X POST -d '{
  "images": [
    "data://okhlopkov/'$CAT_SERVER_PATH'"
  ],
  "savePaths": [
    "data://okhlopkov/'$STYLED_CAT_PATH'"
  ],
  "filterName": "'$RANDOMSTYLE'"
}' \
-H 'Content-Type: application/json' \
-H 'Authorization: Simple '$ALGORITHMIA_TOKEN https://api.algorithmia.com/v1/algo/deeplearning/DeepFilter/0.6.0


###########################
#### Download a styled file
curl -O -H 'Authorization: Simple '$ALGORITHMIA_TOKEN $HTTP_FOLDER_PATH$STYLED_CAT_PATH

###########################
#### Delete a styled file from styler
curl -X DELETE -H 'Authorization: Simple '$ALGORITHMIA_TOKEN $HTTP_FOLDER_PATH$STYLED_CAT_PATH

cd bizon-generator
COMMENT_TEXT="$(node index.js --concat)"
echo "Generated text: "$COMMENT_TEXT
cd ..

python3 post_photo.py $STYLED_CAT_NAME "$COMMENT_TEXT"
rm -f $STYLED_CAT_NAME
