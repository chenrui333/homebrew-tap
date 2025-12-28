class Klepto < Formula
  desc "Tool for copying and anonymising data"
  homepage "https://github.com/hellofresh/klepto"
  url "https://github.com/hellofresh/klepto/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "f62bc59204db301f0f1122e4a9429019afdbe23ac91903252c0b4cf78309507d"
  license "MIT"
  head "https://github.com/hellofresh/klepto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a844368515b23446e7a2b339c3996250027d72282547a218a6da51582c50f89e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d53e68043cd19ec1b69a9fe5f89a6b7d6543dc537af955ecb69bf74687ca2a2e"
    sha256 cellar: :any_skip_relocation, ventura:       "b7f5a9b9674c85a5d8ccf5976effaf47eff0f12f36aeee02b44cf91a41633071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6537cb1d80f4d1c660d8e710003d8360d2ad7865768c5bc329740af80ae8e6a1"
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
