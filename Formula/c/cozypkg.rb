class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "5852fcafe6dd3e354c328d6b89adc3a61b7eb40f681d91a099d614f927d93ce9"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8f6d4a3d8e05275c52c19faa84988903516dab5f2129da18639b867fdd22623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8c417d5407b36eb9121fd4a987bdf48550003dba623ebc39b84ca842718d3de"
    sha256 cellar: :any_skip_relocation, ventura:       "777211f742937f3b17171686ce158ef6bdf15951285a2887324c20bf33a36e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c430edc9dac80b72074b5a325db57e55768862c0bb7aa7ce74a10c8f0301b11"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
