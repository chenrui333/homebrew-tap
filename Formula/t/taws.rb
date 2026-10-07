class Taws < Formula
  desc "Terminal-based AWS resource viewer and manager"
  homepage "https://github.com/huseyinbabal/taws"
  url "https://github.com/huseyinbabal/taws/archive/refs/tags/v1.3.0-rc.7.tar.gz"
  sha256 "c6bd15c5541a4b6a4accb780128642f0cca78c43c741adfbade48062a8f96b51"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66d0952ba506d1d521fb550af410ff9e775f8b772015dff87660f966ab134317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf484f0d39da693ca06effd44437b85bf61caea26d2d9bcdd7d8a700fc1a5c2c"
    sha256 cellar: :any,                 arm64_linux:   "d251bfb92bb3b23dc234999c1d4f9716938cde8986ec142c09c6d9e1e0b877bf"
    sha256 cellar: :any,                 x86_64_linux:  "96c48ee0e5e7680792e86e40fc727bbb3075d85a36bf74fc81205f5d286fc109"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"taws", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"taws"} --version")

    output = shell_output("#{bin/"taws"} not-a-real-command 2>&1", 2)
    assert_match "unrecognized subcommand 'not-a-real-command'", output
  end
end
