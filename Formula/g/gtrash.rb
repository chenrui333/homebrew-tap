class Gtrash < Formula
  desc "Featureful Trash CLI manager: alternative to rm and trash-cli"
  homepage "https://github.com/umlx5h/gtrash"
  url "https://github.com/umlx5h/gtrash/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "66003276073d9da03cbb4347a4b161f89c81f3706012b77c3e91a154c91f3586"
  license "MIT"
  head "https://github.com/umlx5h/gtrash.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gtrash", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtrash --version")
    system bin/"gtrash", "summary"
  end
end
