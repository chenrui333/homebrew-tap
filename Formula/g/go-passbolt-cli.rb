class GoPassboltCli < Formula
  desc "CLI for passbolt"
  homepage "https://www.passbolt.com/"
  url "https://github.com/passbolt/go-passbolt-cli/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4e88aa088b68a7101ca89a97184eb5427aa9b70d52df077f7d56c2ff3672fe06"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40e152a12d2858735e5cb845532f0c9cb29d33bacbf3669370ecdc8de83b621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a55151e1580c0fe4c1b3441102acedda019e6b4e777addacf52854fb4989c33"
    sha256 cellar: :any_skip_relocation, ventura:       "2fa976a8733ad6380434f6c67e7b3185a967a65d9669a0a072db7fd3bfe872f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca7ed6c35d1be4fb5c72ec9b38776306a806d1230b723b595bc7297e8150dd3"
  end

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
