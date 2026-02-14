class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "a951427f7080623d90e044f2032d4fcaa394a457a1652e6ddce0be8b2ef17f20"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "387679a91e7c0e2bb54167dbe1c8bce8aacf3eb442b25c5cf84da5f00be489de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39cb25cbe1ee58c6ffa1a875f1a9f5b4a2fe95be96b82f31d629b97a75adaf0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c6dd84f901587cf331f07ecf2083e2b0b8285b1177ec214f1743f27381192a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97de6778165a44469f641b9c364d17fd40613655d08dd38e9c913de34a8101b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40baf36c5938598c920735642f6f5758853bc31c0f1a50b010c4c02966ab098a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
