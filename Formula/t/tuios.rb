class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "dbe683cd8c3758a613e9d871a8ea9321c6f86bfe4cd6ba44aef8cca6cfe4e2b8"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0690b572ec75db08469cadce071665920838148b3da3ab3c601fea176840a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "981718ad165435b5b80abbcd3df891b137b48f14dfa245140a7d017627e33c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8ecb0b0e0f37bcb7c8e34e91a75ed3d86f3a98a46cf2de8856321b7761cd91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666d4d47ca8dc71dd532ea10f8aeae953a6bdfc594a8f36dde81b0de655808f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee225526834d220067b3c81df4b39f405962efad099cc7fa2f8bd568c8fee94"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
