class Unisondb < Formula
  desc "Log-Native, Real-Time Database for AI and Edge Computing"
  homepage "https://unisondb.io/"
  url "https://github.com/ankur-anand/unisondb/archive/4d17a6016c7c04546e29b87ca71cd71a94400bd0.tar.gz"
  version "0.0.1"
  sha256 "a67fff1b1a17db3b3df128d4ae22fe6e3ba33223a8432e95a0aca0adc9fe07e9"
  license "Apache-2.0"
  head "https://github.com/ankur-anand/unisondb.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71b1f8cb02f87d72ad793e7b8a1f78e226657509fe6b2b6e95f01f61bcf96d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d0da115245b27f9d47500be916d127eb99c2c4f6394cd56c5fb4cdeab30e90f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d5943567b528e8591510aebe2e673d70e3b33a16bf5506847bc13af62615cd"
    sha256 cellar: :any,                 arm64_linux:   "b9bfd3438be13b25f8aaa505431b797b214f0aed3e1502e674d926b43ee124ac"
    sha256 cellar: :any,                 x86_64_linux:  "7227ab7bc3904fb3cc01722f1428119279d1a0f52461a3246e11f46cf8d7447d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/unisondb"
  end

  test do
    assert_match "Database + Message Bus. Built for Edge", shell_output("#{bin}/unisondb help")
  end
end
