class Klepto < Formula
  desc "Tool for copying and anonymising data"
  homepage "https://github.com/hellofresh/klepto"
  url "https://github.com/hellofresh/klepto/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "f62bc59204db301f0f1122e4a9429019afdbe23ac91903252c0b4cf78309507d"
  license "MIT"
  head "https://github.com/hellofresh/klepto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d45b0512d5017e49756d289cdb206fa4e722d3166454bd0d7ddaa9d91884e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d45b0512d5017e49756d289cdb206fa4e722d3166454bd0d7ddaa9d91884e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d45b0512d5017e49756d289cdb206fa4e722d3166454bd0d7ddaa9d91884e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa41945f59f4a4f27c6c5424fc7de85c47464daa7744a68364cf7dfe5c460ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3246b6aadf9342d1c46cd4bec3229072112d6faa7fbc2ec429a3fe35f171700b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hellofresh/klepto/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"klepto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/klepto --version")

    assert_match "Created .klepto.toml", shell_output("#{bin}/klepto init 2>&1")
    assert_match "ActiveUsers = \"users.active = TRUE\"", (testpath/".klepto.toml").read
  end
end
