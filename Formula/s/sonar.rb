class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "6ccf020428d797bcdded6d2f2ecc961b01ad0d38a41e54a526b6c75b33872057"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67377dbfa8a40e4092ddec5e4dad11ff5bfb817775d7736d09588d99b819c27c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67377dbfa8a40e4092ddec5e4dad11ff5bfb817775d7736d09588d99b819c27c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7e27bf856d3998826e3dc8e8d4e2684809ef818c430b1f5b4e04ce69bae9d7"
    sha256 cellar: :any,                 x86_64_linux:  "7c7e04721bddaaf9021dbe7c584c2e6554f2a649f782b41f0d6fb72f64e95471"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "iproute2" # port scanning shells out to `ss`
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sonar",
                                         shell_parameter_format: :cobra,
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar version")

    output = shell_output("#{bin}/sonar init --no-daemon --service web:3000 2>&1")
    assert_match "with 1 service", output
    assert_match "port: 3000", (testpath/"sonar.yaml").read

    output = shell_output("#{bin}/sonar init --no-daemon --service web:3000 2>&1", 1)
    assert_match "sonar.yaml already exists", output
  end
end
