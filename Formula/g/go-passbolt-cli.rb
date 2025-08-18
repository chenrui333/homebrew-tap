class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4e88aa088b68a7101ca89a97184eb5427aa9b70d52df077f7d56c2ff3672fe06"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"passbolt")

    generate_completions_from_executable(bin/"passbolt", "completion")
    mkdir "man"
    system bin/"passbolt", "gendoc", "--type", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/passbolt --version")
    assert_match "Error: serverAddress is not defined", shell_output("#{bin}/passbolt list user 2>&1", 1)
  end
end
