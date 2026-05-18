class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "662ba0945b748f7a5f7b503bb4c6382b5dcfb5eceb4495c218ddd8635f68d4de"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62172d0655a2e112790aca3c7b00defacada4727030ab709919c43d70448ebe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2631b2a41150715686b05c7680d88a9bfe02dd3092762b9c39ff091671d624f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b98c986549fb99d52d4630ff9d4a9365cf64eca8acbf9634a3138ca8b5fd005"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c8c373050f4a06276a4d49a749c06a007611ab701c2b2cd5b3f5fe02bc884b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f5faf3a7b9d069d65027a5eaa1beb57f8ba46bdd701aba39280affc243a3ea3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
