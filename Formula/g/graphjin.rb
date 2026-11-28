class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.27.3.tar.gz"
  sha256 "a366517a1209b4a88e49aff851dfb56165bb3d2bd2a27d5350ebd71d6bebafa9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "999d55d81b96f1896957902bcb473b8008586d88198813fdb88aca6dce5b82fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7514be8b04be0041f114a62d48f75be7eca221b9dc0dd6d25cd6c65a9caa9858"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7d2118c51e9d4126383ff3ecf4eb3a4b1fe7244abad628d5dd7acc3ac71ba5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6480be2fb9738e1d2b946b1ecefb676919112e05e554483debdaad4d9604b844"
    sha256 cellar: :any,                 x86_64_linux:  "ed0ac3384bbfdbb654e25a2b1d41e02c0d683232355adcc9177c7575ba12d877"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
