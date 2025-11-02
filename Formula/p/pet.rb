class Pet < Formula
  desc "Simple command-line snippet manager"
  homepage "https://github.com/knqyf263/pet"
  url "https://github.com/knqyf263/pet/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "2f9ffefefe07f6d2c7b7f75885e748dee3dd63024242ca22f115c85259acc7d9"
  license "MIT"
  head "https://github.com/knqyf263/pet.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/knqyf263/pet/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"pet", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pet version")
    assert_empty shell_output("#{bin}/pet list")
  end
end
