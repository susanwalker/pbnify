# PBNify

## TODO
 - [X] Models:
  - [X] Request
    * input_image
    * output_image
    * input_params (maybe)

 - [ ] Views:
   - [ ] new_request_form (also the landing page)
   - [ ] show_request_form

 - [ ] Controllers:
   - [ ] RequestsController
    - [ ] new
    - [ ] create
    - [ ] show
    - [ ] download

 - [ ] PBN Module (this contains logic to convert an image to PBN)


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
