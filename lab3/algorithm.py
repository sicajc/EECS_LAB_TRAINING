import math
import copy
import random
def relu(pixel):
    if pixel >= 0:
        return pixel
    else:
        return 0

def leakyRelu(pixel):
    if pixel >= 0:
        return pixel
    else:
        return 0.1*pixel

def sigmoid(pixel):
    return 1/(1 + math.exp(-pixel))

def tanh(pixel):
    return (math.exp(pixel) - math.exp(-pixel))/(math.exp(pixel) + math.exp(-pixel))

def zero_padding(img):
    IMAGE_SIZE = len(img)
    padded_img = [ [0 for i in range(IMAGE_SIZE+2)] for j in range(IMAGE_SIZE+2)]
    # Zero-padded
    for i in range(IMAGE_SIZE):
        for j in range(IMAGE_SIZE):
            padded_img[i+1][j+1] = img[i][j]


    return padded_img

def replication(img):
    IMAGE_SIZE = len(img)
    padded_img = [ [0 for i in range(IMAGE_SIZE+2)] for j in range(IMAGE_SIZE+2)]
    # replication
    for i in range(IMAGE_SIZE):
        for j in range(IMAGE_SIZE):
            # First copy
            padded_img[i+1][j+1] = img[i][j]

            # Boundaries
            if i == 0:
                padded_img[0][j+1] = img[0][j]
            if j == 0:
                padded_img[i+1][0] = img[i][0]
            if i == IMAGE_SIZE-1:
                padded_img[IMAGE_SIZE+1][j+1] = img[IMAGE_SIZE-1][j]
            if j == IMAGE_SIZE-1:
                padded_img[i+1][IMAGE_SIZE+1] = img[i][IMAGE_SIZE-1]

            # Corners
            if i == 0 and j == 0:
                padded_img[0][0] = img[0][0]
            if i == 0 and j == IMAGE_SIZE-1:
                padded_img[0][IMAGE_SIZE+1] = img[0][IMAGE_SIZE-1]
            if i == IMAGE_SIZE-1 and j == 0:
                padded_img[IMAGE_SIZE+1][0] = img[IMAGE_SIZE-1][0]
            if i == IMAGE_SIZE-1 and j == IMAGE_SIZE-1:
                padded_img[IMAGE_SIZE+1][IMAGE_SIZE+1] = img[IMAGE_SIZE-1][IMAGE_SIZE-1]

    return padded_img


def convolution(img,kernal):
    IMAGE_SIZE = len(img) -2
    KERNAL_SIZE = len(kernal)

    convolved_img  = [ [0 for i in range(IMAGE_SIZE)] for j in range(IMAGE_SIZE)]
    for i in range(IMAGE_SIZE):
        for j in range(IMAGE_SIZE):
            for k in range(KERNAL_SIZE):
                for l in range(KERNAL_SIZE):
                    convolved_img[i][j] += kernal[k][l] * img[i+k][j+l]

    return convolved_img


def nn(imgs,kernals,opt):
    # Lists of 3 images = []
    # 4 kernals for each images kernals = [[],[],[],[]] , [[],[],[],[]]
    # opt = 0,1,2,3
    # 0 is relu + replication
    # 1 is leaky relu + replication
    # 2 is sigmoid + zero-padding
    # 3 is tanh + zero-padding
    convolved_img = [[] for i in range(3)]
    padded_imgs = []

    # Selecting images
    for idx,img in enumerate(imgs):
        if opt == 0 or opt == 1:
            padded_img = replication(img)
        else:
            padded_img = zero_padding(img)

        padded_imgs.append(padded_img)

        for kernal in kernals[idx]:
            convolved_img[idx].append(convolution(padded_img,kernal))

    print("-------------------------------------Padded img-------------------------------------")
    for idx,s in enumerate(padded_imgs):
        print(f"----------img:{idx}-------------")
        for j in s:
            print(*j)


    print("-------------------------------------Convolved img-------------------------------------")
    for idx,s in enumerate(convolved_img):
        print(f"----------img:{idx}-------------")
        for jdx,i in enumerate(s):
            print(f"----------Conv with Kernal:{jdx}-------------")
            for j in i:
                print(*j)

    outputs = []

    # Summing up convolved results
    for i in range(4):
        conv_result1 = convolved_img[0][i]
        conv_result2 = convolved_img[1][i]
        conv_result3 = convolved_img[2][i]

        temp = conv_result1
        for j in range(len(conv_result1)):
            for k in range(len(conv_result1)):
                temp[j][k] = conv_result1[j][k]+\
                conv_result2[j][k] + conv_result3[j][k]

        outputs.append(temp)

    print("-----------------------------Summing outputs results:-----------------------------")
    for idx,s in enumerate(outputs):
        print(f"--------------{idx}--------------")
        for i in s:
            print(*i)

    image_size = len(conv_result1)

    activation_result = []

    # activation
    for output in outputs:
        activation_img = copy.deepcopy(output)
        # For each pixel of image
        for i in range(image_size):
            for j in range(image_size):
                if opt == 0:
                    activation_img[i][j] = relu(output[i][j])
                elif opt == 1:
                    activation_img[i][j] = leakyRelu(output[i][j])
                elif opt == 2:
                    activation_img[i][j] = sigmoid(output[i][j])
                elif opt == 3:
                    activation_img[i][j] = tanh(output[i][j])


        activation_result.append(activation_img)
        # print(activation_img)


    print("---------------------------------Activation results:---------------------------------")
    for idx,s in enumerate(activation_result):
        print(f"--------------{idx}--------------")
        for i in s:
            print(*i)

    image_size = len(activation_result[0])
    shuffled_img = [[0 for i in range(image_size*2)] for j in range(image_size*2)]
    start_loc =[(0,0),(0,1),(1,0),(1,1)]

    # Pixel shuffling
    for idx,activated_img in enumerate(activation_result):
        start_i , start_j = start_loc[idx]
        for i in range(image_size):
            for j in range(image_size):
                shuffled_img[start_i + i*2][start_j + j*2] = activated_img[i][j]

    # print(shuffled_img)

    return shuffled_img



def main():
    kernals = []
    imgs    = []
    # Generate random 3 groups of kernals each with 4 kernal
    for i in range(3):
        kernals.append([])
        for _ in range(4):
            kernal = [[random.randint(-1,1) for i in range(3)] for j in range(3)]
            kernals[i].append(kernal)

    # Generate random 3 imgs
    for i in range(3):
        img = [[random.randint(0,4) for i in range(4)] for j in range(4)]
        imgs.append(img)

    # imgs[0]
    # kernals[0]

    opt = 0
    processed_img = nn(imgs,kernals,opt)

    print("---------------------------------------Processed img---------------------------------------")
    for idx,s in enumerate(processed_img):
        print(*s)

    processed_img


if __name__ == '__main__':
    # This code won't run if this file is imported.
    main()