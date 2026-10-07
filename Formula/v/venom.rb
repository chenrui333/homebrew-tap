# framework: cobra
class Venom < Formula
  desc "Manage and run your integration tests with efficiency"
  homepage "https://github.com/ovh/venom"
  url "https://github.com/ovh/venom/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "de7ef1f7794d0aa3e3dceb55cc54e44d4a52594bf1e9af0e9c73f85e6071cfd3"
  license "Apache-2.0"
  head "https://github.com/ovh/venom.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "674ea32f20621d07da574627dd8101d219a9a10c835e483edfc1c80a64d18ee3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b52a79183962252499e962366f7b58c425a3740be7c899c0d5dbcb9b2c2497f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a756b6e66e93724512ad41c714b78712b955abf87446ac3469cee3200f0062d0"
    sha256 cellar: :any,                 x86_64_linux:  "6c9a3a5a6c0b644c35092d42432c097c133b4250939bc570a6242231bb111a5e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/ovh/venom.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/venom"

    generate_completions_from_executable(bin/"venom", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/venom version")

    (testpath/"test.yml").write <<~EOS
      name: Simple Test
      testcases:
        - name: Test echo
          steps:
            - script:
                name: Echo Hello
                script: echo "Hello, world!"
                assertions:
                  - result.code ShouldEqual 0
                  - result.systemout ShouldContainSubstring "Hello, world!"
    EOS

    output = shell_output("#{bin}/venom run test.yml").gsub(/\e\[(\d+)m/, "")
    assert_equal <<~EOS, output
      \t  [trac] writing venom.log
       • Simple Test (test.yml)
       \t• Test-echo PASS
      final status: PASS
    EOS
  end
end
