function image = remove_background(image,bool)

if bool
	mask = zeros(size(image));
	mask(33:end-32, 33:end-32) = 1;

	image = image .* uint8(activecontour(image, mask, 150));
else
	BW1 = im2bw(image,graythresh(image));
	image = uint8(BW1).*image;

end