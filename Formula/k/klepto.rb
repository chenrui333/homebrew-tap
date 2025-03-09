class Klepto < Formula
  desc "Protocol Buffer companion tool"
  homepage "https://github.com/hellofresh/klepto"
  url "https://github.com/hellofresh/klepto/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "f62bc59204db301f0f1122e4a9429019afdbe23ac91903252c0b4cf78309507d"
  license "MIT"
  head "https://github.com/hellofresh/klepto.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hellofresh/klepto/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"klepto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/klepto --version")

    assert_match "Created .klepto.toml", shell_output("#{bin}/klepto init 2>&1")
    assert_match "ActiveUsers = \"users.active = TRUE\"", (testpath/".klepto.toml").read
  end
end
