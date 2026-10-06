class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https://github.com/oysttyer/oysttyer"
  url "https://github.com/oysttyer/oysttyer/archive/refs/tags/2.10.0.tar.gz"
  sha256 "3c0ce1c7b112f2db496cc75a6e76c67f1cad956f9e7812819c6ae7a979b2baea"
  head "https://github.com/oysttyer/oysttyer.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ec10ca81e04dbc02bd77f0b6f8132229123dadb21041fdda69a6be34a2472b68"
  end

  deprecate! date: "2024-01-06", because: :repo_archived

  deny_network_access!

  def install
    bin.install "oysttyer.pl" => "oysttyer"
  end

  test do
    IO.popen(bin/"oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end
