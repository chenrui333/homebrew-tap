class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.36.tar.gz"
  sha256 "7c36fcf4a21b509b1422e547838995c16c1ab7e57b2740feeeac9576b7e6f477"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce33c0bf747ce32490d35d04d252657800993573dbbda5f1be92bea51a865d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6604539a0f08dd2f589cd593a19c1f50e17400086891229c456167e9c973b36b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a552573543223c649bab977101d87bc03ff4aed56d4d149e4420a2eaf13a5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e09bfd15c0f25468625e20d53fa7efa40fbfb2beac0cc3d851c3f6fb756f3af7"
    sha256 cellar: :any,                 x86_64_linux:  "3f438210ac73ee6b30b5045a2d7c3cb7b605e0ad3ab4146061a7cf9fba060203"
  end

  depends_on "go" => :build

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
