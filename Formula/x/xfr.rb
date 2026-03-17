class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "080ab02df84b4d1b1a6942a22b9857d9df6e4190d75fbeadca662a9b1a13fca6"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18491007dbf39ec6b35b368f55466dc30c067ad4b281af6a6c68a222aac0bbf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd9753b1a6a190d3a6897f5eac29e6dbf37538ccbbae5ad76c70f8075b277eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1032bf92ff2fed342269307aa24eb99193903d91ba0e1c0278a6319af08ffc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d7fbc5213431a0e9f724234aac86136bf1f7b98f4103471b6ed7fe3136d50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6deced246918edecb1ff9e8985c482b0d1d3dc63d7a51ba6b271005805ba22"
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
