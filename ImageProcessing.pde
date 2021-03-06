void setup()
{
  size(1600, 920);
}

void draw()
{
  /*PImage source;
  source = MinimizedAverageErrorDither(NearestNeighbour(BasicGrayscale(loadImage("http://www.ece.rice.edu/~wakin/images/lena512.bmp", "bmp")), 1), 1);
  println(source.pixels.length);
  image(source,0,0);
  //image(NearestNeighbour(OrderedDither(loadImage("http://www.ece.rice.edu/~wakin/images/lena512.bmp", "bmp"), 1), 1), 0, 0);
   if(keyPressed){
     if(key==ENTER){
       source.save("source.png");
       println("IMAGE SAVED");
     }
   }*/
   PImage source = loadImage("http://www.ece.rice.edu/~wakin/images/lena512.bmp", "bmp");
     float[][] blur9= {{1f/9f,1f/9f,1f/9f},{1f/9f,1f/9f,1f/9f},{1f/9f,1f/9f,1f/9f}};
     float[][] identity= {{0f,0f,0f},{0f,1f,0f},{0f,0f,0f}};
     float[][] edgeDetection8 = {{-1f,-1f,-1f},{-1f,8f,-1f},{-1f,-1f,-1f}};
     float[][] edgeDetection1 = {{0f,1f,0f},{1f,-4f,1f},{0f,1f,0f}};
     float[][] edgeDetection0 = {{1f,0f,-1f},{0f,0f,0f},{-1f,0f,1f}}; 
     image(MinimizedAverageErrorDither(Convolution(source, edgeDetection8), 1), 0, 0);
     image(MinimizedAverageErrorDither(Convolution(source, edgeDetection1), 1), source.width, 0);
     image(MinimizedAverageErrorDither(Convolution(source, edgeDetection0), 1), 2*source.width, 0);
     //image(OrderedDither(NearestNeighbour(BasicGrayscale(source), 1), 1), 0, 0);
     //image(FloydSteinbergDither(NearestNeighbour(BasicGrayscale(source), 1), 1), source.width, 0);
     //image(MinimizedAverageErrorDither(NearestNeighbour(BasicGrayscale(source), 1), 1), 2*source.width, 0);
   if(keyPressed){
     if(key==ENTER){
       saveFrame("source.png");
       println("IMAGE SAVED");
     }
   }
}

PImage NearestNeighbour(final PImage source, final float scaleFactor)
{
 PImage resultImage = createImage(round(source.width * scaleFactor), round(source.height * scaleFactor),  RGB);

 for(int i=0; i<resultImage.height; i++)
 {
   for(int j=0; j<resultImage.width; j++)
   {
     //println("W:" + j + " H:" + i);
     resultImage.pixels[i*resultImage.width + j]
       = source.pixels[floor(i/scaleFactor)*source.width + floor(j/scaleFactor)];
   }
 }
 
 resultImage.updatePixels();
 return resultImage;
}

PImage OrderedDither(final PImage source, int targetPaletteSize)
{
  PImage resultImage = createImage(source.width, source.height, RGB);
  float bayer9[][] = { {0.f/9.f, 7.f/9.f, 3.f/9.f},
                       {6.f/9.f, 5.f/9.f, 2.f/9.f},
                       {4.f/9.f, 1.f/9.f, 8.f/9.f} };
                       
  float bayer16[][] ={ {0.f/16.f, 8.f/16.f, 2.f/16.f, 10.f/16.f},
                       {12.f/16.f, 4.f/16.f, 14.f/16.f, 6.f/16.f},
                       {3.f/16.f, 11.f/16.f, 1.f/16.f, 9.f/16.f},
                       {15.f/16.f, 7.f/16.f, 13.f/16.f, 5.f/16.f} };
  
  float bayer64[][] ={ {0.f/64.f, 48.f/64.f, 12.f/64.f, 60.f/64.f, 3.f/64.f, 51.f/64.f, 15.f/64.f, 63.f/64.f},
                       {32.f/64.f, 16.f/64.f, 44.f/64.f, 28.f/64.f, 35.f/64.f, 19.f/64.f, 47.f/64.f, 31.f/64.f},
                       {8.f/64.f, 56.f/64.f, 4.f/64.f, 52.f/64.f, 11.f/64.f, 59.f/64.f, 7.f/64.f, 55.f/64.f},
                       {40.f/64.f, 24.f/64.f, 36.f/64.f, 20.f/64.f, 43.f/64.f, 27.f/64.f, 39.f/64.f, 23.f/64.f},
                       {2.f/64.f, 50.f/64.f, 14.f/64.f, 62.f/64.f, 1.f/64.f, 49.f/64.f, 13.f/64.f, 61.f/64.f},
                       {34.f/64.f, 18.f/64.f, 46.f/64.f, 30.f/64.f, 33.f/64.f, 17.f/64.f, 45.f/64.f, 29.f/64.f},
                       {10.f/64.f, 58.f/64.f, 6.f/64.f, 54.f/64.f, 9.f/64.f, 57.f/64.f, 5.f/64.f, 53.f/64.f},
                       {42.f/64.f, 26.f/64.f, 38.f/64.f, 22.f/64.f, 41.f/64.f, 25.f/64.f, 37.f/64.f, 21.f/64.f} };
  
  for(int i=0; i<resultImage.height; i++)
 {
   for(int j=0; j<resultImage.width; j++)
   {
     color temp = source.pixels[i*resultImage.width + j];
     float addedValue = (256.f/targetPaletteSize)*(bayer16[i%4][j%4]-0.5f);
     temp = color(red(temp)+addedValue, green(temp)+addedValue, blue(temp)+addedValue);
     temp = ClosestPaletteColor(temp, targetPaletteSize);
     resultImage.pixels[i*resultImage.width+j] = temp;
     //println("RED: " + red(temp) + " GREEN: " + green(temp) + " BLUE: " + blue(temp));
   }
 }
  resultImage.updatePixels();
  return resultImage; 
}

color ClosestPaletteColor(final color source, int targetPaletteSize)
{ 
  return color(round(targetPaletteSize*(red(source)/256.f))*(256.f/targetPaletteSize), 
                  round(targetPaletteSize*(green(source)/256.f))*(256.f/targetPaletteSize),
                  round(targetPaletteSize*(blue(source)/256.f))*(256.f/targetPaletteSize));
}

class MyColor
{
  public MyColor(float red, float green, float blue)
  {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
  public MyColor(float gray)
  {
    this.red = this.green = this.blue = gray;
  }
  public MyColor(int value)
  {
    this.red = red(value);
    this.green = green(value);
    this.blue = blue(value);
  }
  
  public float red = 0, green = 0, blue = 0;
  
  public float[] toMatrix()
  {
    return new float[]{this.red, this.green, this.blue};
  }
  public color toInt()
  {
    return color(red, green, blue);
  }
  public MyColor add(final MyColor source)
  {
    red += source.red;
    green += source.green;
    blue += source.blue;
    return this;
  }
  public MyColor add(final color source)
  {
    red += red(source);
    green += green(source);
    blue += blue(source);
    return this;
  }
  public MyColor add(final float value)
  {
    red += value;
    green += value;
    blue += value;
    return this;
  }
  public MyColor multiply(final float value)
  {
    red *= value;
    green *= value;
    blue *= value;
    return this;
  }
  public MyColor copy()
  {
    return new MyColor(red, green, blue);
  }
  
}
static class ErrorDiffusionDitherMatrices
{
  static float Basic2DMatrix [][] =               { {1,      2f/4f},
                                                    {1f/4f,  1f/4f} };
  
  static float FloydSteinbergMatrix[][] =         { {0,      1,      7f/16f},
                                                    {3f/16f, 5f/16f, 1f/16f} };
                                                    
  static float MinimizedAverageErrorMatrix[][] =  { {0,      0,      1,      7f/48f, 5f/48f},
                                                    {3f/48f, 5f/48f, 7f/48f, 5f/48f, 3f/48f},
                                                    {1f/48f, 3f/48f, 5f/48f, 3f/48f, 1f/48f} };
}

PImage ErrorDiffusionDither(final PImage source, int targetPaletteSize, final float[][] ditherMatrix)
{
  PImage result = source.copy();
  for(int i=0; i<source.height; i++)
  {
    for(int j=0; j<source.width; j++)
    {
      MyColor oldPixel = new MyColor(result.pixels[i*result.width + j]);
      MyColor newPixel = new MyColor(ClosestPaletteColor(oldPixel.toInt(), targetPaletteSize));
      MyColor quantError = oldPixel.copy().add(newPixel.copy().multiply(-1.f));
      result.pixels[i*result.width + j] = newPixel.toInt();
      
      int pixelOffset = ditherMatrix[0].length/2;
      
      for(int matrix_height=0; matrix_height<ditherMatrix.length; matrix_height++)
      {
        for(int matrix_width=0; matrix_width<ditherMatrix[0].length; matrix_width++)
        {
          if(ditherMatrix[matrix_height][matrix_width] == 0){ continue; }
          if(ditherMatrix[matrix_height][matrix_width] == 1){ continue; }
          
          if(i+matrix_height<result.height)
          {
            if(j-pixelOffset+matrix_width>0 && j+matrix_width-pixelOffset<result.width)
            {
              result.pixels[(i+matrix_height)*result.width + j - pixelOffset + matrix_width] =
              new MyColor(result.pixels[(i+matrix_height)*result.width + j - pixelOffset + matrix_width])
                  .add(quantError.copy()
                       .multiply(ditherMatrix[matrix_height][matrix_width]))
                  .toInt();
            }
          } else { continue; }
        } 
      }
    }
  }
  result.updatePixels();
  return result;
}
PImage FloydSteinbergDither(final PImage source, final int targetPaletteSize)
{
  return ErrorDiffusionDither(source, targetPaletteSize, ErrorDiffusionDitherMatrices.FloydSteinbergMatrix);
}

PImage SimpleErrorDiffustionDither(final PImage source, int targetPaletteSize)
{
  return ErrorDiffusionDither(source, targetPaletteSize, ErrorDiffusionDitherMatrices.Basic2DMatrix);
}

PImage MinimizedAverageErrorDither(final PImage source, int targetPaletteSize)
{
  return ErrorDiffusionDither(source, targetPaletteSize, ErrorDiffusionDitherMatrices.MinimizedAverageErrorMatrix);
}

PImage Convolution(final PImage source, final float[][] kernel)
{
  PImage result = createImage(source.width-kernel.length/2, source.height-kernel[0].length/2, RGB);
  //This only implements algorithm for corping Image to prevent needed pixels (for now)
  
  for(int i=kernel.length/2; i< source.height - kernel.length/2; i++)
  {
    for(int j=kernel[0].length/2; j<source.width - kernel[0].length/2; j++)
    {
      MyColor temp = new MyColor(0, 0, 0);
      
      for(int kernel_height=0; kernel_height<kernel.length; kernel_height++)
      {
        for(int kernel_width=0; kernel_width<kernel[0].length; kernel_width++)
        {
          temp.add(new MyColor(source.pixels[(i-(kernel.length/2)+kernel_height)*source.width+j-(kernel[0].length/2)+kernel_width]).multiply(kernel[kernel_height][kernel_width]));
        } 
      }
      result.pixels[i*result.width+j] = temp.toInt();
    }
  }
  result.updatePixels();
  return result;
}

PImage BasicGrayscale(final PImage source)
{
  PImage result = createImage(source.width, source.height, RGB);
  
 for(int i=0; i<source.height; i++)
 {
   for(int j=0; j<source.width; j++)
   {
     color temp = source.pixels[i*source.width+j];
     int gray = int(red(temp)+green(temp)+blue(temp))/3;
     temp = color(gray, gray, gray);
     result.pixels[i*source.width+j] = temp;
   }
 }
  
  return result;
}

float EuclideanDeistance(final float[] a, final float [] b)
{
  assert(a.length == b.length);
  float sum = 0;
  for(int i=0; i<a.length; i++)
  {
    sum += pow(a[i]-b[i], 2);
  }
  return sqrt(sum);
}