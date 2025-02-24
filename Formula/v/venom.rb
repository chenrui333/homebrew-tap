# framework: cobra
class Venom < Formula
  desc "Manage and run your integration tests with efficiency"
  homepage "https://github.com/ovh/venom"
  url "https://github.com/ovh/venom/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "8047a7d20aa5be003684182830ddf05b6133f0761a89256b5791fe665358dff9"
  license "Apache-2.0"
  head "https://github.com/ovh/venom.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ovh/venom.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/venom"

    generate_completions_from_executable(bin/"venom", "completion")
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
