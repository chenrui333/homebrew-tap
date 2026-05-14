class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "145b87b417131c79d9e02ca17e9fcca1839990be6665d7e34f7b41193345e73a"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505dcf804ad7e365b9b60d4fca300632141fd9016807d2b58bf2a4bf01bd797b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bef6dc8282c60e660bec3b1af1b8142c67126052fa8499ef5e2b1aeac25f3b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e097e50675798544e4268ffd1f284660f8227a033d1095d76d52bcb1a66231c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c1b1d72b7711998b59aa01fa4c2d50f43106fb2705ad9659bcc44270ac3af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a088bd1f25e61bcacb554eb7841573534c72afff040e22a16ec1aca5c9bbf52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
