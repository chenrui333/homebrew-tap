class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://github.com/Piebald-AI/splitrail"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "60fadab1d38ce12248df4a16b6cb6213c11c31300a5f207c2f857c0c52295e34"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4567f62a20a2b9d28fc97772607e7b7316aa9cd437c7d85043903582a3dbdb8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dc8f380169d6900e84c5d2bd6928f95fdb2b65e521ae3fb0c7ed01502681bba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eac275b8fdddf6d09ae92dbe2cf9ceb2ff202c47c58895f0577ed512f015e5ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a043cc4053cdd2d158af27fb08ea4381eca6c9587c9da064d9fe401c447a0e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6ef21c1da1cfde5e1a1e32cc957410416690e85002791c2a6dd5afde7afef1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")
  end
end
