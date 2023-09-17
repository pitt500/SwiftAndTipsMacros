# SwiftAndTipsMacros
This repository contains a list of Swift Macros to make your coding live on Apple ecosystem simpler and more productive.

## Content
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SwiftAndTipsMacros](#swiftandtipsmacros)
  - [Content](#content)
  - [#binaryString](#binarystring)
  - [@SampleBuilder](#samplebuilder)
    - [@SampleBuilderItem](#samplebuilderitem)
  - [Add the package to your project](#add-the-package-to-your-project)
  - [Limitations](#limitations)
  - [Future Work](#future-work)
  - [Contributing](#contributing)
  - [Contact](#contact)

<!-- /code_chunk_output -->


## #binaryString
**\#binaryString** is a freestanding macro that will convert an Integer literal into a binary string representation:
```swift
let x = #binaryString(10)
/*
expanded code:
"1010"
*/
print(x) // Output: "1010"
```
> This macro was created as a tutorial to explain how macros work actually. It would be simpler to create a function to do this instead :). Learn more here: TBD

## @SampleBuilder
TBD

### @SampleBuilderItem
TBD

## Add the package to your project
TBD

## Limitations
* Conflict with #Preview and expanded sample code.

## Future Work
* Adding support to CGPoint and more types in random generator mode.

## Contributing
TBD

## Contact
If you have any feedback, I would love to hear from you. Please feel free to reach out to me through any of my social media channels:

* [Youtube](https://youtube.com/@swiftandtips)
* [Twitter](https://twitter.com/swiftandtips)
* [LinkedIn](https://www.linkedin.com/in/pedrorojaslo/)
* [Mastodon](https://iosdev.space/@swiftandtips)

Thanks you, and have a great day! 😄