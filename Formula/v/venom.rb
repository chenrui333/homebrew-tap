# framework: cobra
class Venom < Formula
  desc "Manage and run your integration tests with efficiency"
  homepage "https://github.com/ovh/venom"
  url "https://github.com/ovh/venom/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8047a7d20aa5be003684182830ddf05b6133f0761a89256b5791fe665358dff9"
  license "Apache-2.0"
  head "https://github.com/ovh/venom.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0c116950e759523bb1a478e818e1894b7d0fed64a958f42e8499a257a7aef38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45bf0f445dc8a3c6062e2013cc8e615539b45f5cf44146e2fb2cd85e5c9c338"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a68ace298cf3934a0df8c77c252b81f2f7a90d3b152d0de51a0f15c5c1b08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf148470ac8eb306b770119f2738fbb262995832f1395387a0fe87ebdb0780d2"
  end

  depends_on "go" => :build

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
