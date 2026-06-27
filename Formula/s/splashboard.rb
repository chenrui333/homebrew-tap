class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "8f3980b3fd296a4a66e6301950245555ad39f917d913195305f7b560cdb3dce1"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce0ade407f8fd594639be3288056b1677a38a6212ac7fabd1e6a01e6b2c48544"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb85c41707bc00c57d6e1aca259c3a73b125a80394e75c8390dc804c81f92db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2780dda1f784ac833657ef3e0a8abef09b8145c4d96dfb72131e9003c1b6e235"
    sha256 cellar: :any,                 arm64_linux:   "6f2244665805d4e7f6eece687f7e34ec7f23934a28b3a5feda11e5a099701e8b"
    sha256 cellar: :any,                 x86_64_linux:  "2b5bce2404d2452f05cda4e1824cfb24371f47ac5df66ec83246164ffc08de4c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
