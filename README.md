# PBNify

## TODO
 - [X] Models:
  - [X] Request
    * input_image
    * output_image
    * input_params (maybe)

 - [X] Views:
   - [X] new_request_form (also the landing page)
   - [X] show_request_form

 - [X] Controllers:
   - [X] RequestsController
    - [X] new
    - [X] create
    - [X] show
    - [X] download

 - [X] PBN Module (this contains logic to convert an image to PBN)
  - [X] Improve PBN Module

- [X] Install ImageMagick to CI

- [X] HTTP Basic Authentication

- [X] Remove requests that are 15mins old

- [X] Set up deploy to Heroku

- [X] Set up CD from GitHub to deploy to Heroku when merged to master


## Notes

- This command works for getting rid of black color:
`convert test_image.png -fuzz 25% -fill white -opaque black test_image_output_4.png`
- This command removes the color
`convert test_image.png -fuzz 10% -transparent 'srgba(255,144,0,1)' -transparent black -transparent white -border 20 test_image_output_4.png`
- This command spits out all coordinates and colors of all the pixels (x,y,color)
`convert test_image.png -fuzz 10% -transparent white sparse-color:-`
- Start with 10 most frequently occurring colors and get their coordinates
161,213,srgba(255,144,0,1)
`convert test_image_output_4.png -font Arial -pointsize 5 -draw "gravity south fill black text 33,44 '(1)'" test_image_output_5.png`

## Adding tailwind

- Follow this blog post: https://medium.com/@davidteren/rails-6-and-tailwindcss-getting-started-42ba59e45393


## Heroku Integration

- Follow this post: https://devcenter.heroku.com/articles/getting-started-with-rails4#heroku-gems
