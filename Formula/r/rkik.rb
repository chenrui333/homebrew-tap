class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "417f9cd00bd2785b54d338b51ac0cc413df4ce4d0fca2a3619c704ea78609f33"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5561cdc87122f4f8c5c8d4270865c6419b6d8484f6e47e7fee144b54b912cb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27801294d2dacac06f789c3c24023a7aac621a83bf286ee37fdd6bd3dd521560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e092d1c6fd551b9cfb61295cdf67b1ff5d1f0df70106400a69aced2e434dcd22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe1b3d6707fbb43f7e4b8ab75292349cafa12a508d3fa0a29ddc6d7ea8b342d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2450042c7c6817faba6df12d7f49bbe8db572697686909cd2633a95384b0fcf2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Error querying server 'time.google.com':
    # Input/output error: Resource temporarily unavailable (os error 35)
    return if OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match <<~EOS, shell_output("#{bin}/rkik --server time.google.com --verbose")
      Stratum: 1
      Reference ID: GOOG
    EOS
  end
end
