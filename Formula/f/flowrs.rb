class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "8e18fc941e6a316589bfc7eac38836eb821fd8f5e298eff984fea6bb52017c48"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46f4efec49250665edec837df60b0d873b2763cd678c52ef501ce4928b78516d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e30512d471921ec522b8d1398004001f8df9e2cd08efece89b2e06aa8998b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148ed8718acf800b78d70450d122da994e7b5c0578a4c41cb7406bfe33d8bd13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e22c134240e38c0724c7ae5570343b77079e4b2c31558ca90bc41db426333a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab0f624e8a021432729e44caf511cd2fc45f7ebc8e64d65048a926f7c151ce5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
