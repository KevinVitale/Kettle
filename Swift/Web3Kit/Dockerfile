FROM swift:5.2-development as builder
WORKDIR /root
COPY ./Package.swift ./Package.swift
COPY ./Sources ./Sources
COPY ./Tests   ./Tests
RUN swift build -c release

# FROM swift:slim
# WORKDIR /root
# COPY --from=builder /root .
CMD [".build/x86_64-unknown-linux/release/kettle"]

