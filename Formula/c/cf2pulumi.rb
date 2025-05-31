class Cf2pulumi < Formula
  desc "Convert CloudFormation Templates to Pulumi programs"
  homepage "https://github.com/pulumi/pulumi-aws-native"
  url "https://github.com/pulumi/pulumi-aws-native/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "2703599be132549c12eff463ffd60a4df3ed75230f0bedc6c026b8dad3f71d97"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi-aws-native.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/pulumi/pulumi-aws-native/provider/version.Version=#{version}
    ]
    system "make", "generate_schema"
    cd "provider" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/cf2pulumi"
    end

    generate_completions_from_executable(bin/"cf2pulumi", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf2pulumi version")
  end
end
