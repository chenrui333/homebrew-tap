class Wisu < Formula
  desc "Blazingly fast, minimalist directory tree viewer"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "6a81d75f160558a49d56c15549cbbe7db3d7fb43328ef5c0c881cfa868f485c7"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e98c8dae6e83b1014bb8b9ce7748199b4cefa795a88751d3521991279ddf4cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ab360660fc3233867a54907cff35bb7e969126763635963a085d72ee1065f4"
    sha256 cellar: :any,                 arm64_linux:   "4d5a63237bcab9085f81520eb96c4d8afb8c00024f923cb586c0423d50a84e2a"
    sha256 cellar: :any,                 x86_64_linux:  "4e17027bf3b99e940c64750f4fa3467af6384068b36d0d8e6ebe4d15a466f5a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/^wisu \d+\.\d+\.\d+$/, shell_output("#{bin}/wisu --version"))

    (testpath/"a.txt").write("a\n")
    output = shell_output("#{bin}/wisu #{testpath}")
    assert_match "a.txt", output
  end
end
