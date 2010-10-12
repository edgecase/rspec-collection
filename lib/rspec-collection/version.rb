module RSpecCollection
  module Version
    COMPONENTS = [
      Major = 2,
      Minor = 0,
      Build = 0,
    ]

    STRING = COMPONENTS.join(".")
  end

  VERSION = Version::STRING
end
