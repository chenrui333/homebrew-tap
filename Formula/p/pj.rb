class Pj < Formula
  desc "Fast project directory finder"
  homepage "https://github.com/josephschmitt/pj"
  url "https://github.com/josephschmitt/pj/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "0e860c72842f2127e469c3826de8ea9ee04defbc54996060acd8571206f42413"
  license "MIT"
  head "https://github.com/josephschmitt/pj.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"demo").mkpath
    (testpath/"demo/go.mod").write <<~EOS
      module example.com/demo

      go 1.22
    EOS

    output = shell_output(
      "#{bin}/pj --path #{testpath} --marker go.mod --max-depth 2 --no-cache --format %P",
    )
    assert_equal "#{testpath}/demo\n", output
    assert_match version.to_s, shell_output("#{bin}/pj --version")
  end
end
