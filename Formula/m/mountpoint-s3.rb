class MountpointS3 < Formula
  desc "File client for mounting an Amazon S3 bucket as a local file system"
  homepage "https://github.com/awslabs/mountpoint-s3"
  # mountpoint-s3 reference private header files from aws-c-s3, so better to use the git submodule build
  # https://github.com/awslabs/mountpoint-s3/blob/5e580a8632e30d7616d392fff30eaf215da22cec/mountpoint-s3-crt-sys/build.rs#L59-L62
  url "https://github.com/awslabs/mountpoint-s3.git",
      tag:      "v1.14.0",
      revision: "3da84c54af23c4adb6e1d357ab247a88192f4de7"
  license "Apache-2.0"
  head "https://github.com/awslabs/mountpoint-s3.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "cargo", "install", *std_cargo_args(path: "mountpoint-s3")
  end

  test do
    system bin/"mountpoint-s3", "--help"
  end
end
