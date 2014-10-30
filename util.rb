#! /usr/bin/env ruby
# !/usr/local/bin/ruby

########################################################################
#
# 30/10/14 DH: Created in May 2012 (See '~/src/devlogeD/old/2012/15may')
#
########################################################################

# Variable syntax
# ---------------
# Local  = lowercase letter or underscore name start (within block)
# Global = $ (anywhere in program)
# Instance = @ (instance of "self")
# Class    = @@ (all instances of class)

class GemsUsed
  # Create reader and writer accessor methods for following instance variables...nice, so easy!  Eat shit, Java!
  attr_accessor :gemsListing, :bundleListing
  attr_accessor :gemsList, :bundleList

  def initialize(gemsList, bundleList)
    @gemsListing   = gemsList
    @bundleListing = bundleList
    @gemsList   = Hash.new
    @bundleList = Hash.new
  end 

  # Class method because name prefixed with "self" keyword.
  def self.print(gemsList)
    
    #gemsList.each {|key,value| puts "#{key}\n\t#{value}"}
    #puts "Keys:"+gemsList.keys.sort!.to_s

    sortedGems = gemsList.keys.sort
    sortedGems.each { |key| puts "#{key}\n\t"+gemsList[key] }
  end
 
  def getVersions

    # "gem list" output parsing
    self.gemsListing.each_line do |line|
      linePart = line.split(/[(,)]/)
      gemName = linePart[0].strip
      gemVer1 = linePart[1].strip
      gemVer2 = linePart[2].strip

      #gemName = line.partition(/[(,)]/)[0]

      self.gemsList[gemName] = gemVer1
    end #self.gemsListing.each_line

    # "bundle list" output parsing
    self.bundleListing.each_line do |line|
      linePart = line.split(/[*()]/)
      if linePart.count == 4
        gemName = linePart[1].strip
        gemVer = linePart[2].strip

        self.bundleList[gemName] = gemVer

        #puts "LINE ("+ linePart.count.to_s + " parts): "+line
        #puts "\t1-"+gemName
        #puts "\t2-"+gemVer
      end

    end #self.bundleListing.each_line
  end #getVersions

  def checkBundle
    sortedGems = self.bundleList.keys.sort
    # If no block specified to "max" then uses alphabetical ranking.
    longestKey = sortedGems.max { |a,b| a.length <=> b.length }
    longestVal = self.bundleList.values.max { |a,b| a.length <=> b.length }

    # See "Ruby Kernel Methods" docs for 'sprintf' 'format_string' syntax
    
    # '%[Flags][Width]s':
    #     "-" Flag = Left-justify
    #     "#{longestKey.length}" Width = Display width
    
    printf "%-#{longestKey.length}s VERSION %-#{longestVal.length}s GEMS\n", :GEM, :BUNDLE
    printf "%-#{longestKey.length}s ------- %-#{longestVal.length}s ----\n", "---", "------"


    sortedGems.each do |key|
      if self.bundleList[key] != self.gemsList[key]
        # Using an OLD gem version...
        printf "%-#{longestKey.length}s   OLD   %-#{longestVal.length}s %s\n", key, self.bundleList[key], self.gemsList[key]
      else
        printf "%-#{longestKey.length}s         %-#{longestVal.length}s %s\n", key, self.bundleList[key], self.gemsList[key]
      end
    end

    #puts "longestVal = "+longestVal.to_s
    #puts "longestVal.length = "+longestVal.length.to_s
    #sortedGems.each { |key| puts "#{key}\n\t"+gemsList[key] }

  end #checkBundle

end #class GemsUsed

# Run the code if executed directly from shell
# (equivalent to Java main method)
if __FILE__ == $0

  # "system()" method invokes process but just returns exit value.
  gemsList = `gem list`
  bundleList = `bundle list`
  gems = GemsUsed.new(gemsList,bundleList)

  # Class method won't work here since need instance member attrs
  #GemsUsed.getVersions

  gems.getVersions

=begin (Multi-line comment block which needs to start at column 1)
  puts "GEMS LIST"
  puts "---------"
  GemsUsed.print(gems.gemsList)
  puts "========="

  puts "BUNDLE GEMS LIST"
  puts "----------------"
  GemsUsed.print(gems.bundleList)
  puts "================"
=end

  gems.checkBundle
end #if __FILE__ == $0

