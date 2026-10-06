class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "07e9f21272bd9a1123870ad7e9eb47b0ca27032f8495a163d2407a50b21271f6"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89a78e00105c2751bf1e04c7229a333718680a6fb32b38f90e4d9729f1213943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a78e00105c2751bf1e04c7229a333718680a6fb32b38f90e4d9729f1213943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30eb7ac8e9f4774bfcd7046a54356e1f7e61d0373f24fd334bec732b515e4b0c"
    sha256 cellar: :any,                 x86_64_linux:  "67fa13a79855d0eab19380d2065b69a91409687a4b6910cc66a4d65bdd3e99a5"
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
