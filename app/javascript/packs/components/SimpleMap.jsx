import React, { Component } from "react"
import { compose } from "recompose"
import { withGoogleMap, GoogleMap, Marker, InfoWindow } from "react-google-maps"
import FilterRow from "./FilterRow"

const MapWithAMarker = compose(withGoogleMap)(props => {
  console.log({ props })
  return (
    <GoogleMap
      defaultZoom={12}
      center={{
        lat: props.center.latitude,
        lng: props.center.longitude
      }}
    >
      {props.markers.map(marker => {
        const onClick = props.onClick.bind(this, marker)
        return (
          <Marker
            key={marker.id}
            onClick={onClick}
            position={{ lat: marker.latitude, lng: marker.longitude }}
          >
            {props.selectedMarker === marker && (
              <InfoWindow>
                <div>{marker.shelter}</div>
              </InfoWindow>
            )}
          </Marker>
        )
      })}
    </GoogleMap>
  )
})

export default class ShelterMap extends Component {
  constructor(props) {
    super(props)
    this.state = {
      shelters: [],
      selectedMarker: false,
      center: {
        latitude: 29.7,
        longitude: -95.3
      },
      filters: { filterAccepting: true }
    }
  }
  searchRecords = params => {
    this.setState({ filters: params })
    const url = new URL("/api/v1/shelters", window.location.origin)

    if (params.filterCounty) {
      url.searchParams.append("county", params.filterCounty)
    }
    if (params.filterShelter) {
      url.searchParams.append("shelter", params.filterShelter)
    }
    url.searchParams.append("accepting", params.filterAccepting)
    fetch(url)
      .then(r => r.json())
      .then(data => {
        const shelters = data.shelters.filter(shelter => {
          return shelter.id && shelter.latitude && shelter.longitude
        })
        this.setState({ shelters })
      })
  }
  componentWillUnmount() {
    clearInterval(this.countdown)
  }

  componentDidMount() {
    // Fetch Now
    this.searchRecords(this.state.filters)

    // Fetch every 30 seconds
    this.countdown = setInterval(() => {
      this.searchRecords(this.state.filters)
    }, 30000)

    // Get our current position and move the map there
    navigator.geolocation.getCurrentPosition(position => {
      this.setState({
        center: {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude
        }
      })
    })
  }
  handleClick = (marker, event) => {
    this.setState({
      selectedMarker: marker,
      center: {
        latitude: marker.latitude,
        longitude: marker.longitude
      }
    })
  }
  render() {
    return (
      <article>
        <FilterRow searchRecords={this.searchRecords} />
        <MapWithAMarker
          selectedMarker={this.state.selectedMarker}
          markers={this.state.shelters}
          onClick={this.handleClick}
          center={this.state.center}
          googleMapURL="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=geometry,drawing,places"
          loadingElement={<div style={{ height: `100%` }} />}
          containerElement={<div style={{ height: `100vh` }} />}
          mapElement={<div style={{ height: `100%` }} />}
        />
      </article>
    )
  }
}
