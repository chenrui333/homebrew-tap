class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "56d699ac7d1ddc3b2530178cdfb12e3f781bed2909c18cfede6a508803318a9a"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9264a190c781ea1fb4d7866aaea9fb4a0dc76a69818321685e6eebe4eae056be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2135a29850e2458e5b41134b1d7bda9d738bc76a6e8306c9dc772d9bc82718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c3b680a660f08ae787c4895e08667e17966ce0218bdbc59ae9bbd5db0062456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d04045cdf406212915e230bb629c39e6d68dd930c9ac0041c9d0386fca6be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e8122ae63ede141621c9dc610bbbca0ddbf5281d00a9befc9a42da3acb6a7f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
