class Cooldeck < Formula
  desc "Keyboard-driven terminal dashboard for Coolify"
  homepage "https://github.com/Resetnak/cooldeck"
  url "https://github.com/Resetnak/cooldeck/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "3937c5949946fdb13af0aa2712794e8f52132f812898c1d0d29875ae2fc8422c"
  license "MIT"
  head "https://github.com/Resetnak/cooldeck.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/resetnak/cooldeck/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cooldeck"
    generate_completions_from_executable(bin/"cooldeck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cooldeck version")
    output = shell_output("#{bin}/cooldeck --config #{testpath}/missing.toml config validate 2>&1", 1)
    assert_match "configuration file not found", output
  end
end
