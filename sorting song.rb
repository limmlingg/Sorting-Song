# Welcome to Sonic Pi v3.1

mit_lecture = "D:/NUS/AY1718 S2/MUA1166 Music and Computing/Mid-term Project/Samples/mitlecture.wav"    # use of external samples
drum_loop = "D:/NUS/AY1718 S2/MUA1166 Music and Computing/Mid-term Project/Samples/drumloop.wav"
error_sound = "D:/NUS/AY1718 S2/MUA1166 Music and Computing/Mid-term Project/Samples/windowserror.wav"

###############################
# RECURSIVE SORTING FUNCTIONS #
###############################

##| This function merges the two arrays into one in ascending order
##| Pre-condition: arr1 and arr2 are already sorted
define :merge do |arr1, arr2|
  if arr1.empty?
    return arr2
  elsif arr2.empty?
    return arr1
  end
  
  n = arr1.length + arr2.length
  i = 0
  j = 0
  answer = Array.new(n)
  for k in 0..(n-1)
    if ( (j >= arr2.length) || (i < arr1.length && arr1[i] <= arr2[j]))
      answer[k] = arr1[i]
      i+=1
    else
      answer[k] = arr2[j]
      j+=1
    end
    k+=1
  end
  return answer
end

##| This function splits the array into two smaller arrays to be sorted, then merges them back
define :merge_sort do |arr|
  if arr.length <= 1
    return arr
  else
    mid = (arr.length/2).floor
    left = merge_sort(arr.take(mid))    # 2 methods to process the contents of an array
    right = merge_sort(arr.drop(mid))
    result = merge(left, right)
    play result, sustain: 3, release: 1    # ADSR parameters
    sleep 4
    return result
  end
end

##| This function partitions the array around a pivot (the first element in the array) and returns the position of the pivot
define :partition do |arr, first, last|
  pivot = arr[first]
  play pivot
  sleep 0.5
  
  arr[first], arr[last] = arr[last], arr[first]
  pivot_index = first
  (first..last - 1).each do |i|
    play pivot, amp: 0.3
    sleep 0.5
    play arr[i]
    sleep 0.5
    if arr[i] <= pivot
      arr[i], arr[pivot_index] = arr[pivot_index], arr[i]
      pivot_index += 1
    end
  end
  arr[pivot_index], arr[last] = arr[last], arr[pivot_index]
  return pivot_index
end

##| This function partitions the array around a pivot (the first element in the array) and repeats for the smaller arrays formed
define :quick_sort do |arr, first, last|
  if first < last
    pivot_index = partition(arr, first, last)
    quick_sort(arr, first, pivot_index - 1)
    quick_sort(arr, pivot_index + 1, last)
  end
  return arr
end


##| The intro of the song is a single line melody, illustrating selection sort - the sorting algorithm used by most humans when given a list.
##| The algorithm: go through the array elements one by one and find the smallest one. Move the smallest one to the front. Continue with the rest of the array.
##| This plays the notes of the array in sequence, then the smallest note found. When sorting is complete, it will play all the notes as a chord.
define :intro do |notes|
  n = notes.length
  
  for i in 0..(n-2)
    
    min_index = i
    for j in 0..(n-1)
      play notes[j]
      sleep 0.5
      if ((j > i) && (notes[j] < notes[min_index]))
        min_index = j
      end
    end
    
    if (i < (n-2))
      play notes[min_index]
      sleep 1
    end
    
    temp = notes[i]
    notes[i] = notes[min_index]
    notes[min_index] = temp
    
  end
  
  play notes, sustain: 1
end

##| The leading melody of the first verse is bubble sort, one of the first sorting algorithms taught to students. It is arguably the simplest and most straightforward sorting algorithm.
##| The algorithm: go through the array elements one by one. If the element is smaller than the one on its right, swap those two. Continue until the array is sorted.
##| This will play the notes of the array in sequence. If the element is smaller than the one on its right, it plays the two notes from smaller to larger to illustrate the swap.
##| If you hear a note being played twice consecutively, that means that note is being swapped! You should be able to hear the melody slowly fit an ascending order.
define :verse1_lead do |notes|
  n = notes.length
  
  for i in 0..(n-2)
    
    done = true
    
    for j in 0..(n-2)
      play notes[j]
      sleep 0.25
      
      if (notes[j] > notes[j+1])
        
        play notes[j+1]
        sleep 0.25
        
        notes[j], notes[j+1] = notes[j+1], notes[j]
        
        done = false
        
        play notes[j]
        sleep 0.25
      end
    end
    play notes.last
    sleep 0.25
    break if done
  end
  play notes
end

##| The leading melody of the second verse is shaker sort, an adaptation of bubble sort.
##| The algorithm: the same as bubble sort, but after going through each element left to right, it will go through each element right to left to check if the previous element is bigger than it.
##| This will play the notes of the array in sequence. If the element is smaller than the one on its right, it plays the two notes from smaller to larger to illustrate the swap, and vice versa.
##| If you hear a note being played twice consecutively, that means that note is being swapped! You should be able to hear the melody slowly fit an ascending order, then a descending order.
define :verse2_lead do |notes|
  n = notes.length
  
  n.times do
    done = true
    
    0.upto(notes.length-2) do |i|
      play notes[i]
      sleep 0.25
      if notes[i] > notes[i+1]
        play notes[i+1]
        sleep 0.25
        
        notes[i], notes[i+1] = notes[i+1], notes[i]
        
        done = false
        
        play notes[i]
        sleep 0.25
      end
    end
    
    (notes.length-2).downto(0) do |i|
      if notes[i] > notes[i + 1]
        play notes[i]
        sleep 0.25
        
        notes[i], notes[i+1] = notes[i+1], notes[i]
        
        done = false
        
        play notes[i+1]
        sleep 0.25
      end
    end
    break if done
  end
end

##| The bass part for the verses. This uses merge sort, one of the more efficient sorting algorithms.
##| The algorithm: break down the array into smaller arrays and sort each small array. Afterwards, merge the smaller arrays into a bigger array until the whole array is sorted.
##| This plays the notes in the smaller arrays as a chord, then as the smaller arrays get merged, plays the bigger arrays as a chord.
define :verse_bass do |notes|
  merge_sort(notes)
end

##| The chorus part. This uses quick sort, one of the most popular sorting algorithms, especially in job interviews.
##| The algorithm: find a pivot in the array and compare every element in the array with it. Anything smaller than the pivot goes to the left, anything larger goes to the right. Repeat for both subarrays on the left and right of the pivot.
##| You will hear a certain note being alternated. This note is the pivot! If you hear a note being repeated, that means the pivot is being changed to that note.
define :chorus do |notes|
  n = notes.length
  quick_sort(notes, 0, n-1)
  n.times do
    play notes.tick(:chorus), release: 0.1    # ADSR parameters
    sleep 0.25
  end
end

##| The outro uses bogosort, the best sorting algorithm ever (not).
##| The algorithm: randomly shuffle the elements in the array until the array is sorted. Yup. That's it.
##| This function plays the shuffled notes in sequence, then pauses. Repeats until the notes are sorted.
define :outro do |notes|
  n = notes.length
  sorted = notes.sort
  until notes == sorted
    for i in 0..(n-1)
      play notes[i], sustain: 0.05, release: 0.1    # ADSR parameters
      sleep 0.25
    end
    sleep 0.5
    notes = notes.shuffle    # process the contents of an array
  end
  n.times do
    play notes.tick(:notes)    # use of tick
    sleep 0.25
  end
end

#############
# THE SCORE #
#############

use_bpm 64

in_thread do
  intro([79, 60, 84, 72, 67, 76])
end

in_thread do
  sleep 20
  sample :glitch_robot1, pan: -1
  sleep 1
  sample :glitch_robot2, pan: 1
  sleep 1
  use_synth :piano
  with_fx :bitcrusher, sample_rate: 4000 do    # use of fx
    verse1_lead([77, 63, 72, 65, 60, 81, 67, 75, 79, 62, 84, 70, 82])
  end
  sample :glitch_robot2, pan: -0.5
  sleep 1
  sample :glitch_robot1, pan: 0.5
  sleep 59
  verse2_lead([77, 63, 72, 65, 60, 81, 67, 75, 79, 62, 84, 70, 82])
  sleep 0.75
  sample error_sound, amp: 2
end

in_thread do
  sleep 22
  with_fx :reverb do    # use of fx on multiple instruments
    use_synth :hollow
    verse_bass([65, 51, 60, 53, 48, 69, 55, 63, 67, 50, 62, 58, 70])
    use_synth :pretty_bell
    chorus([80, 62, 82, 77, 70, 72, 84, 74, 67, 63, 65, 79, 60, 68, 75])
    use_synth :hollow
    verse_bass([65, 51, 60, 53, 48, 55, 63, 50])
    sleep 0.25
    use_synth :pretty_bell
    chorus([75, 68, 60, 79, 65, 63, 67, 74, 84, 72, 70, 77, 82, 62, 80])
  end
  use_synth :beep
  outro([79, 76, 84, 72])
end

in_thread do
  sleep 18
  amp_vals = (line 0.0, 0.7, steps: 2, inclusive: true)    # use of line syntax
  
  4.times do
    sample drum_loop, amp: amp_vals.tick(:amp_cres)    # use of tick
    sleep 4
  end
  37.times do
    sample drum_loop
    sleep 4
  end
  3.times do
    sample drum_loop, amp: amp_vals.reverse.tick(:amp_dim)    # use of tick
    sleep 4
  end
end

sleep 18
with_fx :reverb, mix: 0.6, room: 0.8 do    # use of fx on one sample
  sample mit_lecture, rate: 0.55, amp: 0.5   # use of rate on sample
end
